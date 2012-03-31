class ArticleImageController < ApplicationController
  def index
    @article_images = Article_images.all
  end
  
  def show 
    @article_images = Article_images.find_by_params[:article_image]
  end
  
end
