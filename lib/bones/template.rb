class Bones
  # Template - loads template file based on
  # request path information and compiles
  # it using ERB
  class Template
    attr_accessor :path
    attr_accessor :layout
    attr_accessor :options
    attr_accessor :request
    
    # Returns array of all helper files that should
    # be included
    def self.helpers_to_include
      files = [
        Dir.glob(Bones.system_path / 'helpers/*_helper.rb'),
        Dir.glob(Bones.root / 'helpers/*_helper.rb')
      ].flatten
    end
    
    # Load all available helpers
    def self.include_helpers
      helpers_to_include.each do |filename|
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
      if self.path =~ /raw$/
        layout false
        Bones.system_path / 'pages' / 'directory.html.erb'
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
      Bones.layouts_path / layout.to_s + '.html.erb'
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
      # go away, favicon requests
      return String.new if File.basename(filename) =~ /^favicon.ico/
      
      unless File.exist?(filename)
        raise "Template missing\n#{filename}"
      end
      
      src = ERB.new(File.read(filename)).src
      src = (local_assigns_source || '') + (src || '')
      @content_for_layout = eval(src)
      
      if layout && File.file?(layout_filename)
        erb = ERB.new(File.read(layout_filename))
        eval(erb.src) do |*keys|
          key = keys.first
          key = :layout if key.blank?
          instance_variable_get(:"@content_for_#{key}")
        end
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
      path.last.gsub!(/^([^_])/, '_\1')
      name = path.join('/')
      template = Template.new(name, false, options)
      template.request = request
      template.compile
    end
  end  
end