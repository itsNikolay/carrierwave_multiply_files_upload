class Article < ActiveRecord::Base
  #attr_accessible :title, :body, :article_images_attributes
  #belongs_to :gallery
    
  has_many :article_images, :dependent => :destroy
  
  accepts_nested_attributes_for :article_images, allow_destroy: true 
end
