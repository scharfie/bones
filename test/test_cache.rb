require File.dirname(__FILE__) + '/test_helper'

context "Bones::Cache with default options" do
  uses_example_site
  
  setup do
    @cache = Bones::Cache.new
    @page = @cache.process_page('index')
  end
  
  test "should process page correctly" do
    assert_include @page, 'src="/stylesheets/styles.css"'
    assert_include @page, 'action="/comment.html"'
    assert_include @page, 'href="/things/a.html"'
  end
end
  
context "Bones::Cache with custom base" do
  uses_example_site

  setup do
    @cache = Bones::Cache.new(:base => '/mysite')
    @page = @cache.process_page('index')
  end
  
  test "should process page correctly using custom base" do
    assert_include @page, 'src="/mysite/stylesheets/styles.css"'
    assert_include @page, 'action="/mysite/comment.html"'
    assert_include @page, 'href="/mysite/things/a.html"'
  end
end

context "Bones::Cache URL normalization" do
  uses_example_site

  setup do
    @cache = Bones::Cache.new(:base => '/mysite')
  end
  
  def assert_normalized(expected, actual=nil)
    assert_equal(expected, @cache.normalize_url(actual))
  end
  
  def assert_normalized_with_base(url)
    assert_equal @cache.options.base / url, @cache.normalize_url(url)
  end
  
  def assert_not_normalized(url)
    assert_equal url, @cache.normalize_url(url)
  end
  
  test "should not normalize URLs that have a protocol" do
    assert_not_normalized "mailto:someone@example.com"
    assert_not_normalized "http://www.example.com"
    assert_not_normalized "ftp://ftp.example.com"
  end
  
  test "should not add .html to URLs that have an extension" do
    assert_normalized_with_base "/videos/hello.mov"
    assert_normalized_with_base "/articles.rss"
  end
  
  test "should not add .html to URLs in a public directory path" do
    assert_normalized_with_base "/stylesheets"
    assert_normalized_with_base "/images/spacer"
  end
  
  test "should normalize URLs that match page paths" do
    assert_normalized "/mysite/about.html", "/about"
    assert_normalized "/mysite/things/a.html", "/things/a"
  end
end  