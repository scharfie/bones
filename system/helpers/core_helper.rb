module CoreHelper
  def stylesheet_link_tag(*args)
    return nil if args.empty?
    options = Hash === args.last ? args.pop : {}
    result  = args.map {|e| %Q{<link href="/stylesheets/#{e}.css" type="text/css" rel="stylesheet" />} }
    result.join("\n")
  end
  
  def javascript_include_tag(*args)
    return nil if args.empty?
    options = Hash === args.last ? args.pop : {}
    result = args.map { |e| %Q{<script src="/stylesheets/#{e}.js" type="text/javascript"></script>} }
    result.join("\n")
  end
end