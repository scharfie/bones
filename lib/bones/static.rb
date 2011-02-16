class Bones
  class Static < Rack::Static
    def initialize(app, *args, &block)
      super app, :urls => Bones.public_directories, 
        :root => Bones.root / 'public', &block
    end
  end    
end
