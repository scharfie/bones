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
      @original_destination || (Bones.root / 'public')
    end
  
    # Copies all public directories to the new release directory
    def copy_public_directories
      Bones.public_directories.each do |src|
        FileUtils.copy_entry Bones.root / 'public' / src, destination / src
      end
    end  
  end
end
