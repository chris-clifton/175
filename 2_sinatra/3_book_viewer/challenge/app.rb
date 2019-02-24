require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get "/" do
  @folder = Dir.glob("public/*").map {|file| File.basename(file) }.sort
  @folder.reverse! if params[:sort] == "desc"
  erb :home
end

