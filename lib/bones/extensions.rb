class String
  # Join strings using /
  # (i.e. "system" / "pages" -> "system/pages")
  def /(other)
    File.join(self, other)
  end
end

# Loads filename, removing the associated
# class if defined
# 
# Arguments:
#   hash of 'Class' => 'filename' pairs
# 
# Example:
# 
#   force_load 'Application' => 'application.rb'
# 
# will remove the Application class if found,
# and then load the application.rb file
def force_load(map={})
  map.each do |klass, filename|
    Class.remove_class(klass) if Object.const_defined?(klass)
    load filename 
  end
end