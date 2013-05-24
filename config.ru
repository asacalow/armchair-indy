require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'logger'
require './quick_search'

logger = Logger.new('log/app.log')
use Rack::CommonLogger, logger

Compass.configuration do |config|
  config.project_path = QuickSearch.root
  config.sass_dir     = File.join('assets', 'stylesheets')
end

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/fonts'
  environment.append_path HandlebarsAssets.path
  run environment
end

map '/' do
  run QuickSearch
end