require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'

enable :sessions

get '/' do
    erb :index
end

get '/signup' do
    erb :signup
end