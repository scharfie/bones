require File.dirname(__FILE__) + '/test_helper'

context "Bones Template" do
  uses_example_site
  
  setup do
    @template = Bones::Template.new('')
  end

  test "should return proper filename for top-level files" do
    @template.path = 'about'
    assert_include @template.filename, '/about.html.erb'
  end
  
  test "should return proper filename for directories" do
    @template.path = 'things'
    assert_include @template.filename, '/things/index.html.erb'
  end
  
  test "should return proper filename for files in directories" do
    @template.path = 'things/a'
    assert_include @template.filename, '/things/a.html.erb'
  end
  
  test "should return proper layout filename" do
    @template.layout = 'example_layout'
    assert_equal Bones.layouts_path / 'example_layout.html.erb', @template.layout_filename
  end
  
  test "should invoke custom helper" do
    assert_include @template.some_custom_helper, 'Some custom helper'
  end
  
  test "should render partial partials/footer" do
    assert_include @template.partial('partials/footer'), 'Footer text'
  end
  
end

context "Bones template helpers" do
  uses_example_site

  def assert_include_helper(helper)
    assert_include Bones::Template.helpers_to_include, helper
  end

  test "should include system core helper" do
    assert_include_helper Bones.system_path / 'helpers/core_helper.rb'
  end

  test "should include user custom helper" do
    assert_include_helper Bones.root / 'helpers/custom_helper.rb'
  end
end  

context "Bones template 'about'" do
  uses_example_site
  
  setup do
    @template = Bones::Template.new('about')
    @template.request = TestRequest.new(:path_info => 'about')
    @response = @template.compile
  end
  
  test "should use layout 'example_layout'" do
    assert_equal 'example_layout', @template.layout
    assert_include @response, 'Example Layout'
  end
end