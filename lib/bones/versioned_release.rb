class Bones
  # Class used to encapsulate the logic needed to
  # maintain mockup versions
  class VersionedRelease < Release
    # Pre-fix used for versioned directories
    DIR_PREFIX = 'v'
  
    def initialize(original_destination, release_destination = nil)
      super
      @release_destination = get_versioned_destination
    end
    
    # Returns the versioned directories within the 'public' folder
    # $> Bones::Versioned.directories
    # $> => ["/v1", "/v2", ... "/vN"]
    def self.directories(base=nil)
      base ||= Bones.root / 'public'
      FileUtils.mkdir_p(base) unless File.directory?(base)
      Dir.chdir(base) do
        Dir.glob("#{DIR_PREFIX}**").inject([]) do |dirs, dir|
          dirs << '/' + File.basename(dir) if dir =~ /^#{DIR_PREFIX}\d+$/
          dirs
        end.compact
      end
    end
  
    # Public accessor of version
    def version
      next_version
    end
  
    # Returns directory name of versioned path
    # For example, 'v1'
    def versioned_directory_name
      DIR_PREFIX + next_version
    end

  private
    # increments to the next version based on existing versions
    def next_version
      (self.class.directories(original_destination).size + 1).to_s
    end
  
    # constructs the next version path
    def get_versioned_destination
      original_destination / versioned_directory_name
    end
  end  
end