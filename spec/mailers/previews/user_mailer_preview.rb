# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def password_reset
    user = User.first
    user.reset_password_token = User.new_token
    UserMailer.password_reset(user)
  end
end
