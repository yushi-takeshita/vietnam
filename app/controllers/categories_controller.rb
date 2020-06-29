class CategoriesController < ApplicationController
  def new
    @children = Category.find(params[:parent_id]).children
    respond_to do |format|
      format.html
      format.json
    end
  end

  def index
    @posts = Category.find(params[:id])
  end
end
