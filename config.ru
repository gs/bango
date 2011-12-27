# This file is used by Rack-based servers to start the application.

require 'rubygems'
Gem.clear_paths
require ::File.expand_path('../config/environment',  __FILE__)
run Bango::Application
