class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @category = Category.find_by(id: params[:category_id])
    @q = Post.ransack(params[:q])
    if params[:category_id]
      @posts = Category.find(params[:category_id]).posts.all.page(params[:page])
    else
      @posts = @q.result(distinct: true).page(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
    @category = @post.category
    @comment = Comment.new
    @comments = @post.comments.all
  end

  def new
    @post = current_user.posts.build
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, flash: { success: t(".flash.掲示板を投稿しました") }
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

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :image)
  end
end
