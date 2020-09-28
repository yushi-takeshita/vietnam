class HomeController < ApplicationController
  def top
    @user = User.new
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).page(params[:page]).per(10)
    return unless params[:category_id]

    @posts = Category.find(params[:category_id]).posts.all.page(params[:page]).per(10)
  end

  def useful_pages; end
end
