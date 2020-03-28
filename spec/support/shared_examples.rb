# encoding: UTF-8

shared_examples "ユーザー登録が成功すること" do
  it {
    # マイページへリダイレクトされる
    @user = User.find_by(email: "test1@example.com")
    expect(current_path).to eq user_path(@user)

    # 登録成功のフラッシュが表示される
    expect(page).to have_css ".alert-success"
  }
end
shared_examples "ログイン状態であること" do
  it {
    # (プロフィールの)編集とログアウトのリンクが表示される
    within ".card-body" do
      expect(page).to have_css ".card-link"
    end

    # ヘッダーにマイページが表示される
    find(".navbar-toggler").click
    expect(page).to have_css ".mypage"

    # ヘッダーからログアウト時に見えるリンクが除外される
    expect(page).not_to have_css ".login"
    expect(page).not_to have_css ".create-account"

    # トップページに表示されていたサイト紹介文とログインフォームが除外される
    visit root_path
    expect(page).not_to have_css ".introduction"
  }
end
shared_examples "ユーザー登録が失敗すること" do
  it {
    # 登録フォームに何も入力せずに登録ボタンをクリックする
    # DBのユーザー数は増えない
    expect { find(".btn-primary").click }.not_to change { User.count }

    # 会員登録ページに戻る(「会員登録の入力」と表示されたまま)
    expect(page).to have_css "h1.signup"

    # エラーが表示される
    expect(page).to have_css "#error_explanation"
  }
end

shared_examples "エラーが表示されること" do
  it { expect(page).to have_css "#error_explanation" }
end

shared_examples "パスワード再設定ページが表示される" do
  it {
    expect(page).to have_field "user[password]"
    expect(page).to have_field "user[password_confirmation]"
    expect(find("#email", visible: false)).not_to be_visible
  }
end
