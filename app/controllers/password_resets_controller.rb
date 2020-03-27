class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, flash: { info: "メールに記載されたリンクからパスワード再設定ページへアクセスしてください" }
    else
      flash.now[:danger] = "メールアドレスが見つかりません"
      render "password_resets/new"
    end
  end

  def edit
  end
end
