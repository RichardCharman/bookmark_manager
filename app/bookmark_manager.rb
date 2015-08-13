require 'sinatra/base'
require_relative "../data_mapper_setup"
require_relative "./models/link"
require_relative "./models/tag"

class BookmarkManager < Sinatra::Base
  configure :development do
    set :bind, '0.0.0.0'
    set :port, 3000
  end
  
  get '/' do
    erb :start
  end  
  
  get '/links' do
    @links = Link.all
    erb :index
  end   

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    (params[:tags].split).each do |tag| tag = Tag.first_or_create(name: tag)
    link.tags << tag  
    end
    link.save
    redirect to('/links')
  end
  
  get '/links/new' do
    erb :create_links
  end 
  
  get "/tags" do
    redirect to("/tags/#{params[:name]}")
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :index
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end