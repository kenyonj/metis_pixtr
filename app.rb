require 'sinatra'
require 'pg'

database = PG.connect( dbname: 'photo_galleries' )

get '/' do
  erb :index
end

get '/galleries/:id' do
  id = params[:id]
  gallery = database.exec_params(
    "SELECT * FROM galleries WHERE id = $1", 
    [id]
  ).first
  @title = gallery["name"].capitalize
  images = database.exec_params(
    "SELECT * FROM images WHERE gallery_id = $1", 
    [id]
  )
  @images = images.map { |image| image["url"] }
  erb :gallery
end

get '/newpicture' do
  name = params["name"]
  desc = params["desc"]
  gallery_id = params["gallery_id"]
  url = params["url"]
  database.exec_params(
    "INSERT INTO images(name, description, gallery_id, url) VALUES ($1, $2, $3, $4)",
    [name, desc, gallery_id, url]
  )
  redirect to("/galleries/#{gallery_id}")
end
