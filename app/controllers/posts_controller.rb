# encoding: utf-8

class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.save
    flash[:notice] = "Đăng thành công"
    redirect_to posts_url
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Loại bỏ thành công"
    redirect_to posts_url
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
