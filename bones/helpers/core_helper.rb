module CoreHelper
  # Returns array of tag names that can be
  # closed with /> instead of </tagname>
  def short_tag_names
    %w(input br link hr)
  end

  # Converts hash of options into a string of HTML
  # property="value" pairs
  def html_options_from_hash(options={})
    options.map do |key, value|
      %Q{#{key}="#{value}"}
    end.join(' ')
  end
  
  # Creates a tag with content and properties
  # Example:
  #   content_tag(:div, "Hello", :id => 'greeting')
  #     -- generates --
  #   <div id="greeting">Hello</div>
  def content_tag(name, *arguments)
    name    = name.to_s
    options = Hash === arguments.last ? arguments.pop : {}
    properties = html_options_from_hash(options)
    
    result = ["<#{name}"]
    result << ' ' + properties unless properties.empty?
    
    if short_tag_names.include?(name)
      result << ' />'
    else
      result << '>'
      result << arguments.join
      result << "</#{name}>"  
    end  
  end
  
  def stylesheet_link_tag(*sources)
    return nil if args.empty?
    options = Hash === sources.last ? sources.pop : {}
    result  = args.map { |e| stylesheet_tag(e, options) }
    result.join("\n")
  end
  
  def stylesheet_tag(name, options={})
    options.reverse_merge! :href => "/stylesheets/#{name}.css",
      :rel => 'stylesheet', :type => 'text/css'
      
    content_tag :link, options  
  end

  def javascript_include_tag(*sources)
    return nil if args.empty?
    options = Hash === sources.last ? sources.pop : {}
    result  = args.map { |e| javascript_tag(e, options) }
    result.join("\n")
  end

  def javascript_tag(name, options={})
    options.reverse_merge! :src => "/javascripts/#{name}.js",
      :type => 'text/javascript'
      
    content_tag :script, options  
  end
end