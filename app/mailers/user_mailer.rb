class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: t("user_mailer.password_resets.パスワード再設定のご案内")
  end
end
