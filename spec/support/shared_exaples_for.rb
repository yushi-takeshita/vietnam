# encoding: UTF-8

shared_examples_for "ユーザー登録が成功すること" do
  it {
    fill_in "user[name]", with: "テストユーザー"
    fill_in "user[email]", with: "test1@example.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"

    # DBのユーザー数が1増える
    expect { find(".btn-primary").click }.to change { User.count }.by(1)

    # マイページへリダイレクトされる
    @user = User.find_by(email: "test1@example.com")
    expect(current_path).to eq user_path(@user)

    # 登録成功のフラッシュが表示される
    expect(page).to have_css ".alert-success"
  }
end
shared_examples_for "ユーザー登録が失敗すること" do
  it {
    # 登録フォームに何も入力せずに登録ボタンをクリックする
    # DBのユーザー数は増えない
    expect { find(".btn-primary").click }.not_to change { User.count }

    # 会員登録ページに戻る(「会員登録の入力」と表示されたまま)
    expect(page).to have_css ".signup"

    # エラーが表示される
    expect(page).to have_css "#error_explanation"
  }
end
shared_examples_for "ログインされていること" do
  it {
    # ヘッダーにマイページが表示される
    find(".navbar-toggler").click
    expect(page).to have_css ".mypage"

    # ログアウト時に見えるリンクが除外される
    expect(page).not_to have_css ".login"
    expect(page).not_to have_css ".create-account"

    # トップページに表示されていたサイト紹介文とログインフォームが除外される
    visit root_path
    expect(page).not_to have_css ".introduction"
  }
end
