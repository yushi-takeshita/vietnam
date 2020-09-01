class HomeController < ApplicationController
  def top
    @user = User.new
    @q = Post.ransack(params[:q])
    @posts = if params[:category_id]
               Category.find(params[:category_id]).posts.all.page(params[:page]).per(10)
             else
               @q.result(distinct: true).page(params[:page]).per(10)
             end
  end

  def useful_pages; end
end
