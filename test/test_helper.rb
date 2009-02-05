$:.unshift(File.dirname(__FILE__) + '/../')
require 'lib/boot'
require 'test/unit'

class String
  def only_alphanumeric
    self.gsub(/[^a-zA-Z0-9]/, '_').squeeze('_')
  end
  
  def to_test_method_name
    'test_' + self.downcase.only_alphanumeric
  end
  
  def to_test_class_name
    only_alphanumeric.camelize + 'Test'
  end
end

def context(name, &block)
  Object.const_set(name.to_s.to_test_class_name, Class.new(Test::Unit::TestCase, &block))
end 

class Test::Unit::TestCase
  def self.test(name, &block)
    define_method(name.to_test_method_name, &block)
  end
  
  def self.setup(&block)
    define_method(:setup, &block)
  end
  
  def self.uses_example_site
    Bones.root = File.expand_path(File.dirname(__FILE__) / 'example_site')
    define_method(:teardown) do
      Bones.reset_paths!
    end
  end

  def relative_path(path)
    File.expand_path(File.dirname(__FILE__) / path)
  end
  
  def assert_include(collection, obj, message=nil)
    assert collection.include?(obj), message
  end
end