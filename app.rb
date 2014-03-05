require 'sinatra'
require 'pg'
require 'active_record'

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'photo_galleries'
})

class Gallery < ActiveRecord::Base
  has_many :images
end

class Image < ActiveRecord::Base
end

get '/' do
  @galleries = Gallery.all
  erb :index
end

get '/galleries/:id' do
  id = params[:id]
  gallery = Gallery.find(id)
  @title = gallery.name.capitalize
  @images = gallery.images
  erb :gallery
end

get '/newpicture' do
  name = params["name"]
  desc = params["desc"]
  gallery_id = params["gallery_id"]
  url = params["url"]
  if name != nil && desc != nil && gallery_id != nil && url != nil
    image = Image.new
    image.name = name
    image.description = desc
    image.gallery_id = gallery_id
    image.url = url
    image.save
    redirect to("/galleries/#{gallery_id}")
  else
    "Sorry, you have not fully defined an image."
  end

end
