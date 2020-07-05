class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new]

  def index
    @q = Post.ransack(params[:q])
    if params[:category_id]
      @posts = Category.find(params[:category_id]).posts.all.page(params[:page])
    else
      @posts = @q.result(distinct: true).page(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def edit; end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "Đăng thành công"
      redirect_to root_url
    else
      render "new"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Loại bỏ thành công"
    redirect_to posts_url
  end
end
