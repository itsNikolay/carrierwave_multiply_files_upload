class ArticleImage < ActiveRecord::Base
  
  #attr_accessible :image, :remote_image_url, :remove_image
  
  mount_uploader :image, ImageUploader
  
  belongs_to :article

  

end
