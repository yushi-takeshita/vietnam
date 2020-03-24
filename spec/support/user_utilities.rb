module UserUtilities
  def login_as(user)
    visit login_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    find(".btn-primary").click
  end
end
