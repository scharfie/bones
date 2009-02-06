require File.dirname(__FILE__) + '/test_helper'

context "Bones Example Site" do
  uses_example_site
  
  test "should have proper paths" do
    assert_equal relative_path('./example_site'),         Bones.root
    assert_equal relative_path('./example_site/pages'),   Bones.pages_path
    assert_equal relative_path('./example_site/layouts'), Bones.layouts_path
  end
  
  test "should have pages" do
    assert 3, Bones.pages.length
    assert ['about', 'index', 'things/a'], Bones.pages
  end
end