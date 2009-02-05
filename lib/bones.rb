# Bones - the _real_ request handler,
# which BonesProxy loads and calls upon to
# do the dirty work.
class Bones
  class << self
    attr_accessor :base, :root
    attr_accessor :system_path, :pages_path, :layouts_path
    attr_accessor :booted
    
    def base
      @base || ''
    end
    
    # Path to the root of the bones project
    # Defaults to current directory
    def root
      @root ||= File.expand_path('.')
    end
    
    # Path to the bones system files
    # Defaults to the directory containing this file
    def system_path
      @system_path ||= File.expand_path(File.dirname(__FILE__))
    end
    
    # Path to the directory containing the page templates
    #   [root]/pages
    def pages_path
      @pages_path || root / 'pages'
    end
    
    # Path to the directory containing the layout templates
    #   [root]/layouts
    def layouts_path
      @layouts_path || root / 'layouts'
    end
    
    def booted?
      @booted
    end
  end
  
  # Process incoming request (for real this time!)
  def call(env)
    # Grab the request
    request  = Rack::Request.new(env) 
    
    # Create a new template for the given path
    # and compile it
    template = Template.new(request.path_info)
    template.request = request
    output   = template.compile

    # Build a rack response
    Rack::Response.new.finish do |response|
      response.write output
    end    
  end
  
  # Returns array of all pages (excluding partials)
  def self.pages
    Dir.chdir(Bones.pages_path) do
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
    attr_accessor :request
    
    # Load all available helpers
    def self.include_helpers
      files = [
        Dir.glob(Bones.system_path / 'helpers/*_helper.rb'),
        Dir.glob(Bones.root / 'helpers/*_helper.rb')
      ].flatten
      
      # Include each helper
      files.each do |filename|
        klass = File.basename(filename, '.rb').camelize
        force_load klass => filename
        include klass.constantize
      end
    end
    
    # Load the helpers
    include_helpers if Bones.booted?
    
    # Initialize template with path and optional layout
    def initialize(path, layout=-1, options={})
      @path    = path.gsub(/\.html|\.html\.erb/, '')
      @layout  = layout == -1 ? 'application' : layout
      @options = options
      
      self.class.include_helpers
    end
    
    def inspect
      '#<Bones::Template @path="%s" @layout="%s">' % [path, layout]
    end
    
    # Full path to template file
    def filename
      if @path =~ /raw$/
        layout false
        path = Bones.system_path / 'pages' / 'directory.html.erb'
      else
        path = Bones.pages_path / @path
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
      path = Bones.layouts_path / layout.to_s + '.html.erb'
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
      
      if layout && File.file?(layout_filename)
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
      template = Template.new(name, false, options)
      template.request = request
      template.compile
    end
  end
end