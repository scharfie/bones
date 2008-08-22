# Bones - the _real_ request handler,
# which BonesProxy loads and calls upon to
# do the dirty work.
class Bones
  # Process incoming request (for real this time!)
  def call(env)
    # Grab the request
    request  = Rack::Request.new(env) 
    
    # Create a new template for the given path
    # and compile it
    template = Template.new(request.path_info)
    output   = template.compile

    # Build a rack response
    Rack::Response.new.finish do |response|
      response.write output
    end    
  end
  
  # Returns array of all pages (excluding partials)
  def self.pages
    Dir.chdir(PAGES) do
      Dir.glob('**/*.html.erb').map do |f|
        f.starts_with?('_') ? nil : f.gsub('.html.erb', '')
      end.compact
    end
  end  
  
  # Template - loads template file based on
  # request path information and compiles
  # it using ERB
  class Template
    attr_accessor :path
    attr_accessor :layout
    attr_accessor :options
    
    # Load all available helpers
    def self.include_helpers
      files = [
        Dir.glob(SYSTEM / 'helpers/*_helper.rb'),
        Dir.glob(ROOT / 'helpers/*_helper.rb')
      ].flatten
      
      # Include each helper
      files.each do |filename|
        klass = File.basename(filename, '.rb').camelize
        force_load klass => filename
        include klass.constantize
      end
    end
    
    # Load the helpers
    include_helpers if Object.const_defined?(:SYSTEM)
    
    # Initialize template with path and optional layout
    def initialize(path, layout=-1, options={})
      @path    = path.gsub(/\.html|\.html\.erb/, '')
      @layout  = layout == -1 ? 'application' : layout
      @options = options
    end
    
    # Full path to template file
    def filename
      if @path =~ /raw$/
        layout false
        path = SYSTEM / 'pages' / 'directory.html.erb'
      else
        path = PAGES / @path
        path /= 'index' if File.directory?(path) or path.ends_with?('/')
        path += '.html.erb'
      end
    end
    
    # Returns array of pages
    def pages
      Bones.pages
    end
    
    # Full path to layout file
    def layout_filename
      path = LAYOUTS / layout.to_s + '.html.erb'
    end
    
    # Gets/sets layout
    # If no argument is passed, the layout is returned;
    # otherwise, sets the layout 
    # (use false or nil to turn off the layout)
    def layout(arg=-1)
      @layout = arg unless arg == -1
      @layout
    end
    
    # Compiles the template (along with the layout
    # if necessary)
    def compile
      src = ERB.new(File.read(filename)).src
      src = (local_assigns_source || '') + (src || '')
      @content_for_layout = eval(src) # erb.result(binding)
      
      if layout
        erb = ERB.new(File.read(layout_filename))
        erb.result(binding)
      else
        @content_for_layout
      end  
    end
    
    # Generates source for local variable assignments
    def local_assigns_source
      src = []
      (options[:locals] || {}).each do |key, value|
        src << "#{key} = #{value.inspect};\n"
      end
      src.join
    end
    
    # Short-hand for compiling a template
    def self.compile(*args)
      Template.new(*args).compile
    end
    
    # Renders partial template - an underscore
    # is automatically added to the passed name,
    # so <%= partial 'footer' %> will render
    # the '_footer.html.erb' template.
    def partial(name, options={})
      path = name.to_s.split('/')
      path[-1] = '_' + path.last unless path.last.starts_with?('_')
      name = path.join('/')
      Template.compile(name, false, options)
    end
  end
  
  # Class used to encapsulate the logic needed to
  # maintain mockup versions
  class Versioned
    # Pre-fix used for versioned directories
    DIR_PREFIX = 'v'
    
    # Start with the original destination
    def initialize(original_destination)
      @original_destination = original_destination
      @versioned_destination = nil
    end
    
    # Returns the new destination, which depends on
    # the existing amount of 'versions'
    def destination      
      @versioned_destination ||= get_versioned_destination
    end
    
    # Copies all public directories to the new 'versioned'
    # directory, so each version can contain it's own mockup
    # (note: only copies asset directories - ignores "v1", "v2", etc)
    def copy_public_directories
      public_directories.each do |src|
        FileUtils.copy_entry ROOT / 'public' / src, destination / src
      end
    end
    
    # Returns the versioned directories within the 'public' folder
    # $> Bones::Versioned.directories
    # $> => ["/v1", "/v2", ... "/vN"]
    def self.directories
      Dir.glob(ROOT / 'public' / "#{DIR_PREFIX}**").inject([]) do |dirs, dir|
        dirs << '/' + dir.gsub(/^\/.+\//, '')
      end
    end
    
    # Public accessor of version
    def version
      next_version
    end
    
    # Returns directory name of versioned path
    # For example, 'v1'
    def versioned_directory_name
      DIR_PREFIX + next_version
    end

  private
    # increments to the next version based on existing versions
    def next_version
      (self.class.directories.size + 1).to_s
    end
    
    # constructs the next version path
    def get_versioned_destination
      @original_destination /= versioned_directory_name
    end
  end
end