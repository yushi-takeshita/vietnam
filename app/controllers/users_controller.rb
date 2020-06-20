# encoding: UTF-8

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index; end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      redirect_to @user, flash: { success: t("users.create.flash.会員登録が完了しました") }
    else
      render "users/new"
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, flash: { success: t("users.update.flash.プロフィールを編集しました") }
    else
      render "users/edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url, flash: { success: "アカウントを削除しました" }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = t("users.new.flash.ログインしてください")
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  # Adminユーザーかどうか確認
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
