class Application
  def call(env)
    request  = Rack::Request.new(env) 
    template = Template.new(request.path_info)
    output   = template.compile

    Rack::Response.new.finish do |response|
      response.write output
    end    
  end
  
  class Template
    attr_accessor :path
    attr_accessor :layout
    
    def self.include_helpers
      files = [
        Dir.glob(SYSTEM / 'helpers/*_helper.rb'),
        Dir.glob(ROOT / 'helpers/*_helper.rb')
      ].flatten
      
      files.each do |e|
        klass = File.basename(e, '.rb').camelize
        Class.remove_class(klass) if Object.const_defined?(klass)
        load e
        include klass.constantize
      end
    end
    
    include_helpers
    
    def initialize(path)
      @path = path
      @layout = 'application'
    end
    
    def filename
      if @path =~ /raw$/
        @layout = false
        generate_directory_listing
        path = SYSTEM / 'pages' / 'directory.html.erb'
      else
        path = PAGES / @path
        path /= 'index' if File.directory?(path) or path.ends_with?('/')
        path += '.html.erb'
      end
    end
    
    def layout_filename
      path = LAYOUTS / layout.to_s + '.html.erb'
    end

    def generate_directory_listing
      Dir.chdir(PAGES) do
        @files = Dir.glob('**/*.html.erb').map do |f|
          f.gsub('.html.erb', '')
        end
      end
    end
    
    def layout(arg=nil)
      @layout = arg unless arg.nil?
      @layout
    end
    
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
    
    def partial(name)
      e = Template.new("_#{name}")
      e.layout(false)
      e.compile
    end
    
    
    # def yield(variable='content_for_layout')
    #   instance_variable_get("@#{variable}")
    # end
  end
end