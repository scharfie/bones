require 'rubygems'

gem 'activesupport', '>= 2.3.10'
gem 'rack',          '>= 0.3.0'

require 'rack'
require 'active_support'
require 'active_support/dependencies'
require 'active_support/core_ext'
require 'pathname'
require 'yaml'
require 'fileutils'
require 'optparse'
require 'ostruct'
require 'erb'

require Pathname.new(__FILE__).dirname.join('bones/bones.rb')
require Pathname.new(__FILE__).dirname.join('bones/extensions.rb')

ActiveSupport::Dependencies.autoload_paths.push Bones.system_path
$:.push Bones.system_path

Bones.booted = true
