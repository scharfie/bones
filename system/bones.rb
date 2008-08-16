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
    include_helpers
    
    # Initialize template with path and optional layout
    def initialize(path, layout=-1)
      @path   = path
      @layout = layout == -1 ? 'application' : layout
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
      erb = ERB.new(File.read(filename))
      @content_for_layout = erb.result(binding)
      
      if layout
        erb = ERB.new(File.read(layout_filename))
        erb.result(binding)
      else
        @content_for_layout
      end  
    end
    
    # Short-hand for compiling a template
    def self.compile(*args)
      Template.new(*args).compile
    end
    
    # Renders partial template - an underscore
    # is automatically added to the passed name,
    # so <%= partial 'footer' %> will render
    # the '_footer.html.erb' template.
    def partial(name)
      Template.compile("_#{name}", false)
    end
  end
end