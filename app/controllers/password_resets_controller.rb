class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, flash: { info: "受信メールからパスワード再設定ページへアクセスして下さい ※届いていない場合は迷惑メールBOXも確認して下さい" }
    else
      flash.now[:danger] = "メールアドレスが見つかりません"
      render "password_resets/new"
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
    unless @user && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
end
