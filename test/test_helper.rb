$:.unshift(File.dirname(__FILE__) + '/../')
require 'lib/bones'
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
  class << self; attr_accessor :bones_root; end
  
  def self.test(name, &block)
    define_method(name.to_test_method_name, &block)
  end
  
  def self.setup(&block)
    define_method(:setup, &block)
  end

  # def self.reset_bones
  #   Bones.reset
  #   Bones.root = File.expand_path(File.dirname(__FILE__) + '/../../')
  # end
  
  def self.uses_example_site
    self.bones_root = Pathname.new(__FILE__).dirname.join('example_site').expand_path.to_s
  end

  def run_with_bones_root(*args, &block)
    with_bones_root do
      run_without_bones_root(*args, &block)
    end  
  end
  
  alias_method_chain :run, :bones_root unless method_defined?(:run_without_bones_root)
  
  def with_bones_root(root=nil, &block)
    previous_root, Bones.root = Bones.root, (root || self.class.bones_root)
    yield(block)
    Bones.root = previous_root
  end
  
  def relative_path(path)
    Pathname.new(__FILE__).dirname.join(path).expand_path.to_s
  end
  
  def assert_include(collection, obj, message=nil)
    message ||= "expected #{collection.inspect} to include #{obj.inspect}"
    assert collection.include?(obj), message
  end
end

class TestRequest < OpenStruct
end
