

$> rails g scaffold Article title body:text

Gemfile
`#Add this gems
gem 'carrierwave'
gem 'rmagick'`

$> bundle


rails g model Article_image image article_id

rake db:migrate

rails generate uploader Image

app/uploaders/image_uploader.rb
  include CarrierWave::RMagick # Uncomment this line

. . .

   version :thumb do # Uncomment this line
     process :resize_to_limit => [200, 200] # Change on this line
   end # And this =)

. . .


app/models/article.rb
class Article < ActiveRecord::Base
  #attr_accessible :title, :body, :article_images_attributes
    
  has_many :article_images, :dependent => :destroy
  
  accepts_nested_attributes_for :article_images, allow_destroy: true 
end


app/models/article_image.rb
class ArticleImages < ActiveRecord::Base
#attr_accessible :image  
  mount_uploader :image, ImageUploader  
  belongs_to :article
end


app/controllers/articles_controller.rb

def show
    @article = Article.find(params[:id])
    @images = @article.article_images # Add this line (extract all article's images)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

def new
    @article = Article.new
     @article.article_images.build # Adding this line
    #3.times {@article.article_images.build} # This line for multyply file upload with 
one action

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

 def edit
    @article = Article.find(params[:id])
     @article.article_images.build # Adding this line
    #3.times {@article.article_images.build} # This line for multyply file upload with 
one action
  end


app/views/articles/_form.html.erb
<%= form_for @article, :html => {:multipart => true} do |f| %>

. . .

<%= f.fields_for :article_images do |article_image| %>

<% if article_image.object.new_record? %>

<%= article_image.file_field :image %>

<% else %>

<%= image_tag(article_image.object.image.url(:thumb)) %>
<%= article_image.check_box :_destroy %>

<% end %>

<% end %>

. . .

<% end %> 


app/views/articles/show.html.erb
. . .

<p>
  <b>Images:</b>
  <% @article.article_images.each do |article_image| %>
		<%= link_to(image_tag(article_image.image.url(:thumb)), 
article_image.image.url) %>
	<% end %>
</p>

. . .
