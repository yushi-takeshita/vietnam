module LoginMacros
  def login_as(user)
    visit login_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    find(".btn-primary").click
    expect(current_path).to eq user_path(I18n.locale, user)
  end

  def logout
    find(".navbar-toggler").click
    find(".logout").click
    expect(current_path).to eq root_path(I18n.locale)
  end

  def act_as(user)
    login_as(user)
    yield
    logout
  end
end
