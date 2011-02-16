class String
  # Join strings using /
  # (i.e. "system" / "pages" -> "system/pages")
  def /(other)
    File.join(self, other)
  end
end


class Object
  def self.remove
    
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
    if defined?(klass.name)
      basename = klass.to_s.split("::").last
      parent = klass.parent
      
      # Skip this class if it does not match the current one bound to this name
      next unless parent.const_defined?(basename) && klass = parent.const_get(basename)

      parent.instance_eval { remove_const basename } unless parent == klass
    end

    load filename 
  end
end
