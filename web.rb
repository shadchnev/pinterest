require 'sinatra'
require 'mongo'

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
