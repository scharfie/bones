class Bones
  class Release
    attr_accessor :original_destination
    attr_accessor :release_destination
  
    # Create new release
    def initialize(original_destination, release_destination)
      @original_destination = original_destination
      @release_destination  = release_destination
    end
  
    # Accessor for release destination
    def destination
      @release_destination
    end
    
    def original_destination
      @original_destination || (ROOT / 'public')
    end
  
    # Copies all public directories to the new release directory
    def copy_public_directories
      public_directories.each do |src|
        FileUtils.copy_entry ROOT / 'public' / src, destination / src
      end
    end  
  end

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
      base ||= ROOT / 'public'
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