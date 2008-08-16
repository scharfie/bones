SYSTEM  = File.dirname(__FILE__)
ROOT    = File.expand_path(SYSTEM + '/../')
PAGES   = File.join(ROOT, 'pages')
LAYOUTS = File.join(ROOT, 'layouts')

$:.unshift(SYSTEM)

require 'yaml'
require 'rack'
require 'rack/request'
require 'rack/response'
require 'activesupport'
require 'extensions'
require 'erb'