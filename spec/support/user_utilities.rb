module UserUtilities
  def valid_login
    find(".navbar-toggler").click
    find(".login").click
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    find(".btn-primary").click
  end
end
