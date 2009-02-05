require File.dirname(__FILE__) + '/test_helper'

class BonesTest < Test::Unit::TestCase
  test "should have proper paths" do
    assert_equal relative_path('.'),         Bones.root
    assert_equal relative_path('../lib'),    Bones.system_path
    assert_equal relative_path('./pages'),   Bones.pages_path
    assert_equal relative_path('./layouts'), Bones.layouts_path
  end
  
  test "should allow getting/setting Bones.base" do
    assert_equal '', Bones.base
    Bones.base = '/something'
    assert_equal '/something', Bones.base
  end
end