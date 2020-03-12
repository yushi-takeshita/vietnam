# encoding: UTF-8

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      login user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = "入力情報が正しくありません"
      render "new"
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
