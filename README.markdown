# Carrierwave nested_attributes_form and multiply images uploding

Our carrierwave images will be placed on Article model
<pre><code>$> rails g scaffold Article title body:text</pre></code>

**Gemfile**
<pre><code>
. . .
gem 'carrierwave'
gem 'rmagick'
. . .
</pre></code>

<pre><code>
$> bundle
</pre></code>

## Model
<pre><code>$> rails g model Article_image image article_id</pre></code>

<pre><code>$> rake db:migrate</pre></code>

<pre><code>$> rails generate uploader Image</pre></code>

**app/models/article.rb**
<pre><code>
class Article < ActiveRecord::Base
  #attr_accessible :title, :body, :article_images_attributes
  has_many :article_images, :dependent => :destroy  
  accepts_nested_attributes_for :article_images, allow_destroy: true 
end
</pre></code>


**app/models/article_image.rb**
<pre><code>
class ArticleImages < ActiveRecord::Base
  #attr_accessible :image  
  mount_uploader :image, ImageUploader  
  belongs_to :article
end
</pre></code>

## Controller

**app/controllers/articles_controller.rb**
<pre><code>
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
   #3.times {@article.article_images.build} # This line for multyply file upload with one action
  respond_to do |format|
    format.html # new.html.erb
    format.json { render json: @article }
  end
end

def edit
  @article = Article.find(params[:id])
  @article.article_images.build # Adding this line
  #3.times {@article.article_images.build} # This line for multyply file upload with one action
end
</pre></code>
  
## View

**app/views/articles/_form.html.erb**
<pre><code>
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
</pre></code>

**app/views/articles/show.html.erb**
<code>
	<% @article.article_images.each do |article_image| %>
	<%= link_to(image_tag(article_image.image.url(:thumb)), 
	article_image.image.url) %>
	<% end %>
</code>

## Configuration depends on your needs

**app/uploaders/image_uploader.rb**
<pre><code>
include CarrierWave::RMagick # Uncomment this line
. . .
version :thumb do # Uncomment this line
process :resize_to_limit => [200, 200] # Change on this line
end # And this =)
. . .
</pre></code>

_http://localhost:3000/articles_