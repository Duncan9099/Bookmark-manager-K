require 'sinatra/base'
require_relative './lib/bookmarks'
require_relative './lib/comment'
require_relative './lib/tag'
require_relative './lib/bookmark_tag'
require_relative './database_connection_setup'
require 'sinatra/flash'
require 'uri'

class BookmarkManager < Sinatra::Base
  enable :method_override, :sessions
  register Sinatra::Flash

  get '/' do
    "Bookmark Manager"
  end

  get '/bookmarks' do
    @user = User.find(session[:user_id])
    @bookmarks = Bookmarks.all
    erb(:bookmarks)
  end

  get '/bookmarks/new' do
    erb(:"bookmarks/new")
  end

  delete '/bookmarks/:id' do
    Bookmarks.delete(id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark_id = params[:id]
    erb :'bookmarks/edit'
  end

  patch '/bookmarks/:id' do
    Bookmarks.update(id: params[:id], title: params[:title], url: params[:url])
    redirect '/bookmarks'
  end

  post '/bookmarks' do
    flash[:notice] = "Not a valid URL!" unless Bookmarks.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb :'comments/new'
  end

  post '/bookmarks/:id/comments' do
    Comment.create(text: params[:comment], bookmark_id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/tags/new' do
    @bookmark_id = params[:id]
    erb :'/tags/new'
  end

  post '/bookmarks/:id/tags' do
    tag = Tag.create(content:params[:tag])
    BookmarkTag.create(bookmark_id: params[:id], tag_id: tag.id)
    redirect '/bookmarks'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect '/bookmarks'
  end

  run! if app_file == $0
end
