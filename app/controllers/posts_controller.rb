class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to posts_url
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

end
