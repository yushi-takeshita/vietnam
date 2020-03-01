module UserUtilities
  def valid_login
    @user = FactoryBot.create(:user, email: "a@example.com")
    find(".navbar-toggler").click
    click_link "ログイン"
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード", with: @user.password
    click_button "ログイン"
    expect(current_path).to eq user_path(@user)
  end
end
