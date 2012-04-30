# CarrierWave nested_attributes_form and multiple image uploading tutorial

Created on 01.04.2012 (with gem CarrierWave v 0.6.0 https://github.com/jnicklas/carrierwave)

See also:

  * http://lucapette.com/rails/multiple-files-upload-with-carrierwave-and-nested_form/
  * https://github.com/lucapette/carrierwave-nested_form

## CarrierWave images will be located on model Article

```bash
$> rails g scaffold Article title body:text
```

**Gemfile**
```ruby
gem 'carrierwave'
gem 'rmagick'
```

```bash
$> bundle
```

## Model

```bash
$> rails g model Article_image image article_id
$> rake db:migrate
$> rails generate uploader Image
```

**app/models/article.rb**

```ruby
class Article < ActiveRecord::Base

  # NOTE: If using attr_accessible, you must whitelist the nested attribute writer.
  # attr_accessible :title, :body, :article_images_attributes
  
  has_many :article_images, :dependent => :destroy  
  accepts_nested_attributes_for :article_images, :allow_destroy => true 
end
```

**app/models/article_image.rb**
```ruby
class ArticleImages < ActiveRecord::Base

  # attr_accessible :image  
  mount_uploader :image, ImageUploader  
  belongs_to :article
end
```

## Controller

**app/controllers/articles_controller.rb**
```ruby
def show
  @article = Article.find(params[:id])
  @images = @article.article_images # Add this line (extract all article's images).
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @article }
  end
end

def new
  @article = Article.new
  @article.article_images.build # Adding this line
   # 3.times { @article.article_images.build } # This line for multiple files with one action.
  respond_to do |format|
    format.html # new.html.erb
    format.json { render json: @article }
  end
end

def edit
  @article = Article.find(params[:id])
  @article.article_images.build # Adding this line
  # 3.times { @article.article_images.build } # This line for multiple files with one action.
end
```
  
## View

**app/views/articles/_form.html.erb**
```erb
<%= form_for @article, :html => {:multipart => true} do |f| %>

  <%= f.fields_for :article_images do |article_image| %>
    <% if article_image.object.new_record? %>
      <%= article_image.file_field :image %>
    <% else %>
      <%= image_tag(article_image.object.image.url(:thumb)) %>
      <%= article_image.check_box :_destroy %>
    <% end %>
  <% end %>

<% end %> 
```

**app/views/articles/show.html.erb**
```erb
<% @article.article_images.each do |article_image| %>
  <%= link_to(image_tag(article_image.image.url(:thumb)), article_image.image.url) %>
<% end %>
```

## Configuration depends on your needs

**app/uploaders/image_uploader.rb**
```ruby

# Uncomment this line for image processing.
# include CarrierWave::RMagick

# Uncomment these lines to enable thumbnails, change size as required.
# version :thumb do 
#   process :resize_to_limit => [200, 200]
# end
```

_http://localhost:3000/articles_