class PasswordResetsController < ApplicationController
  before_action :check_valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, flash: { info: t("password_resets.create.flash.受信メールからパスワード再設定ページへアクセスして下さい") }
    else
      flash.now[:danger] = t("password_resets.create.flash.メールアドレスが見つかりません")
      render "password_resets/new"
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render "edit"
    elsif @user.update(user_params)
      login @user
      redirect_to @user, flash: { success: t("password_resets.update.flash.パスワードの再設定が完了しました") }
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # before

  # 有効なユーザーか確認する
  def check_valid_user
    @user = User.find_by(email: params[:email])
    redirect_to root_url unless @user&.authenticated?(:reset, params[:id])
  end

  # トークンが有効切れかどうか確認する
  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_url,
                  flash: { danger: t("password_resets.edit.flash.パスワード再設定の有効期限が切れています。初めからやり直して下さい。") }
    end
  end
end
