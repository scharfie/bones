module CoreHelper
  module HTML
    # Creates a tag with content and properties
    # Example:
    #   content_tag(:div, "Hello", :id => 'greeting')
    #     -- generates --
    #   <div id="greeting">Hello</div>
    def content_tag(name, *arguments, &block)
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
        result << capture(&block) if block_given?
        result << "</#{name}>"  
      end
    
      result = result.join('')
      concat(result, block.binding) if block_given?
      result
    end

    # Returns array of tag names that can be
    # closed with /> instead of </tagname>
    def short_tag_names
      %w(input br link hr img)
    end

    # Converts hash of options into a string of HTML
    # property="value" pairs
    def html_options_from_hash(options={})
      options.map do |key, value|
        %Q{#{key}="#{value}"}
      end.sort.join(' ')
    end
  
    # Creates link tag to stylesheet(s)
    # (options are support as the last argument)
    def stylesheet_link_tag(*sources)
      return nil if sources.empty?
      options = Hash === sources.last ? sources.pop : {}
      result  = sources.map { |e| stylesheet_tag(e, options) }
      result.join("\n")
    end
  
    # Creates a stylesheet link tag
    def stylesheet_tag(name, options={})
      options.reverse_merge! :href => "/stylesheets/#{name}.css",
        :rel => 'stylesheet', :type => 'text/css'
      
      content_tag :link, options  
    end

    # Creates script tag to javascript(s)
    # (options are support as the last argument)
    def javascript_include_tag(*sources)
      return nil if sources.empty?
      options = Hash === sources.last ? sources.pop : {}
      result  = sources.map { |e| javascript_tag(e, options) }
      result.join("\n")
    end

    # Creates a javascript script tag
    def javascript_tag(name, options={})
      options.reverse_merge! :src => "/javascripts/#{name}.js",
        :type => 'text/javascript'
      
      content_tag :script, options  
     end
  end
  
  module Capture
    def content_for(name, content = nil, &block)
      existing_content_for = instance_variable_get("@content_for_#{name}").to_s
      new_content_for      = existing_content_for + (block_given? ? capture(&block) : content)
      instance_variable_set("@content_for_#{name}", new_content_for)
    end

    def capture(*args, &block)
      # execute the block
      begin
        buffer = eval('_erbout', block.binding)
      rescue
        buffer = nil
      end
    
      if buffer.nil?
        capture_block(*args, &block).to_s
      else
        capture_erb_with_buffer(buffer, *args, &block).to_s
      end
    end

    def capture_block(*args, &block)
      block.call(*args)
    end
  
    def capture_erb(*args, &block)
      buffer = eval(ActionView::Base.erb_variable, block.binding)
      capture_erb_with_buffer(buffer, *args, &block)
    end

    def capture_erb_with_buffer(buffer, *args, &block)
      pos = buffer.length
      block.call(*args)
  
      # extract the block 
      data = buffer[pos..-1]
  
      # replace it in the original with empty string
      buffer[pos..-1] = ''
  
      data
    end
    
    def concat(string, binding)
      eval('_erbout', binding) << string
    end
  end
  
  include HTML
  include Capture
end