require 'rubygems'
require 'bundler'
Bundler.require(:default)
require './elasticsearch'
require 'sinatra/asset_pipeline'

class SearchMethod < Poncho::JSONMethod
  param :q, :required => true
  param :p
  param :pp

  def invoke
    CollectionItem.search(param(:q), page: param(:p), per_page: param(:pp))
  end
end

class QuickSearch < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  set :assets_css_compressor, Sprockets::Sass::Compressor.new
  set :assets_js_compressor, Uglifier.new
  register Sinatra::AssetPipeline

  get '/' do
  	haml :index
  end

  get '/search',   &SearchMethod
end