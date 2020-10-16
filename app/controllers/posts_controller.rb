class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[new create edit update destroy]
  before_action :admin_or_correct_user, only: %i[edit destroy update]

  def index
    @q = Post.ransack(params[:q])
    @category = Category.find_by(id: params[:category_id])
    if @category
      ids = [] << @category.id
      ids.push(*@category.child_ids)
      @posts = Post.where(category_id: ids).all.page(params[:page]).per(15)
    else
      @posts = @q.result(distinct: true).page(params[:page]).per(15)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def edit
    if @post.created_at < 10.minutes.ago && !current_user.admin?
      redirect_to category_path, flash: { danger: t(".投稿後10分以内であれば修正が可能です") }
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

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, flash: { success: t(".flash.掲示板を編集しました") }
    else
      render "posts/edit"
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
