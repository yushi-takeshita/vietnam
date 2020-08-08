class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_or_correct_user, only: [:edit, :destroy, :update]

  def index
    @category = Category.find_by(id: params[:category_id])
    @q = Post.ransack(params[:q])
    if params[:category_id]
      @posts = Category.find(params[:category_id]).posts.all.page(params[:page]).per(15)
    else
      @posts = @q.result(distinct: true).page(params[:page]).per(15)
    end
  end

  def show
    @post = Post.find(params[:id])
    @category = @post.category
    @user = @post.user
    @comment = Comment.new
    @comments = @post.comments.all
  end

  def new
    @post = current_user.posts.build
  end

  def edit
    if @post.created_at < 10.minutes.ago && !current_user.admin?
      redirect_to category_path, flash: { danger: "投稿後10分以内であれば修正が可能です" }
    end
  end

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
    redirect_to category_path, flash: { success: t(".flash.掲示板を削除しました") }
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :image)
  end

  # 正しいユーザーもしくはAdminユーザーかどうか確認
  def admin_or_correct_user
    @post = Post.find(params[:id])
    redirect_to root_url if !current_user.admin? && !current_user?(@post.user)
  end
end
