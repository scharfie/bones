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
    def root
      @root ||= Pathname.new(__FILE__).dirname.dirname.expand_path.to_s
    end
    
    # Path to the bones system files
    # Defaults to the lib
    def system_path
      @system_path ||= Pathname.new(__FILE__).dirname.dirname.expand_path.to_s
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
  
  # Resets root, pages, and layouts paths and the base setting
  def self.reset
    @pages_path = @layouts_path = @root = @base = nil
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
    # Rack::Response.new.finish do |response|
    #   response.write output
    # end    
    [200, { 'Content-Type' => 'text/html'}, output]
  end
  
  # Returns array of all pages (excluding partials)
  def self.pages
    Dir.chdir(Bones.pages_path) do
      Dir.glob('**/*.html.erb').map do |f|
        f.starts_with?('_') ? nil : f.gsub('.html.erb', '')
      end.compact
    end
  end  
end