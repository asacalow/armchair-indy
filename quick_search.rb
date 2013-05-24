require './elasticsearch'

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

  get '/' do
  	haml :index
  end

  get '/search',   &SearchMethod
end