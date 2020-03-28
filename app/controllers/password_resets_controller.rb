class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

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

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render "edit"
    elsif @user.update_attributes(user_params)
      login @user
      redirect_to @user, flash: { success: "パスワード再設定が完了しました" }
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # before

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 有効なユーザーか確認する
  def valid_user
    unless @user && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  # トークンが有効切れかどうか確認する
  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_url, flash: { danger: "パスワード再設定の有効期限が切れています。初めからやり直して下さい。" }
    end
  end
end
