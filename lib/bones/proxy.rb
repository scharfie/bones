# BonesProxy is simply a proxy class handler
# to the actual Bones class - the reason for 
# this is to allow live changes to Bones
# and helpers, etc.  The proxy reloads on every 
# request
class Bones
  class Proxy
    # Process incoming request
    def call(env)
      reload!
      Bones.new.call(env)  
    end
  
    # Reloads the application
    def reload!
      force_load 'Bones' => File.join(File.dirname(__FILE__), '..', 'bones.rb')
    end
  end  
end