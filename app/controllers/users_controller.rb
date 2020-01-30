# encoding: utf-8

class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Đăng ký người dùng hoàn tất"
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
