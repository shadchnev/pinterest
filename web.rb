require 'sinatra'
require 'mongo'
require 'amazon/aws'
require 'amazon/aws/search'

include Amazon::AWS
include Amazon::AWS::Search

def collection
  unless @db
    uri = URI.parse(ENV['MONGOHQ_URL'])
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    @db = conn.db(uri.path.gsub(/^\//, ''))
  end
  @db['stats']
end

get '/' do
  stats = collection.find_one
  stats ? stats["redirects"].to_s : "0"
end

get '/submit' do  
  @images = []
  if params["keywords"]
    is = ItemSearch.new('All', { 'Keywords' => params["keywords"]}) 
    rg = ResponseGroup.new('Images')
    req = Request.new
    req.search(is, rg) do |resp|
      resp.item_search_response.items[0].item.each do |i|
        @images << {"url" => i.medium_image.url, "asin" => i.asin}
      end
    end
  end
  haml :submit
end

get '/:id' do  
  return unless params["id"].length == 10
  stats = collection.find_one
  unless stats
    collection.insert({"redirects" => 0})
    stats = collection.find_one
  end
  stats["redirects"] += 1
  collection.update({"_id" => stats["_id"]}, stats)
  redirect "http://www.amazon.com/dp/-/#{params["id"]}?tag=beautthing05-20"
end



