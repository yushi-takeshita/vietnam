shared_context "正しい情報が入力された場合" do
  before "正しい情報を入力する" do
    fill_in "user[name]", with: "テストユーザー"
    fill_in "user[email]", with: "test1@example.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    find(".btn-primary").click
  end
end
