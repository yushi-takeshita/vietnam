# encoding: UTF-8

# Railsチュートリアル9.1.4　複数ウィンドウを使ったログアウトテスト　難しいのでスルー

require "rails_helper"
require "byebug"

RSpec.describe "ユーザー管理機能", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    visit root_path
  end

  describe "ユーザー登録機能" do
    context "会員登録ページから登録する場合" do
      before do
        # ハンバーガーメニューから会員登録ページへ移動する
        find(".navbar-toggler").click
        find(".create-account").click
      end
      context "正しい情報が入力された場合" do
        it "ユーザー登録が成功すること" do
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

          # ログインされていること
          # ヘッダーにマイページが表示される
          find(".navbar-toggler").click
          expect(page).to have_css ".mypage"

          # ログアウト時に見えるリンクが除外される
          expect(page).not_to have_css ".login"
          expect(page).not_to have_css ".create-account"

          # トップページに表示されていたサイト紹介文とログインフォームが除外される
          visit root_path
          expect(page).not_to have_css ".introduction"
        end
      end
      context "誤った情報が入力された場合" do
        it "ユーザー登録が失敗すること" do
          # 登録フォームに何も入力せずに登録ボタンをクリックする
          # DBのユーザー数は増えない
          expect { find(".btn-primary").click }.not_to change { User.count }

          # 会員登録ページに戻る(「会員登録の入力」と表示されたまま)
          expect(page).to have_css "h1.signup"

          # エラーが表示される
          expect(page).to have_css "#error_explanation"
        end
      end
    end
    # あとでリファクタリング
=begin
    context "トップページから登録する場合" do
      context "正しい情報が入力された場合" do
        it_behaves_like "ユーザー登録が成功すること"
        it_behaves_like "ログインされていること"
      end
      context "誤った情報が入力された場合" do
        it_behaves_like "ユーザー登録が失敗すること"
      end
    end
=end
  end

  describe "ログイン機能" do
    before do
      # ハンバーガーメニューからログインページへ移動する
      find(".navbar-toggler").click
      find(".login").click
    end

    context "正しい情報が入力された場合" do
      it "ログインに成功すること" do
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        find(".btn-primary").click

        # マイページへリダイレクトされる
        expect(current_path).to eq user_path(user)

        # ログインされていること
        # ヘッダーにマイページが表示される
        find(".navbar-toggler").click
        expect(page).to have_css ".mypage"

        # ログアウト時に見えるリンクが除外される
        expect(page).not_to have_css ".login"
        expect(page).not_to have_css ".create-account"

        # トップページに表示されていたサイト紹介文とログインフォームが除外される
        visit root_path
        expect(page).not_to have_css ".introduction"
      end
    end
    context "誤った情報が入力された場合" do
      it "ログインに失敗すること" do
        # ログインフォームに何も入力せずにログインボタンをクリックする
        find(".btn-primary").click

        # ログインページに戻る
        expect(page).to have_css "h1.login"
        # Flashのエラーが表示される
        expect(page).to have_css(".alert-danger")

        # ページを更新するとFlashが消えている
        visit login_path
        expect(page).to_not have_css(".alert-danger")
      end
    end
  end

  context "ログインしている時" do
    let(:user) { FactoryBot.create(:user, email: "a@example.com") }

    before do
      valid_login
      expect(current_path).to eq user_path(user)
    end

    describe "ログアウト機能" do
      it "ログアウトされていること" do
        # ログアウトをクリック
        all(".card-link")[1].click
        expect(current_path).to eq root_path

        # ログアウト時のリンクが表示される
        find(".navbar-toggler").click
        expect(page).to have_css ".login"
        expect(page).to have_css ".create-account"

        # トップページのサイト紹介文とログインフォームが表示される
        expect(page).to have_css ".introduction"
      end
    end

    describe "プロフィール編集機能" do
      before do
        # 編集をクリック
        all(".card-link")[0].click
      end

      it "編集フォームに編集前の情報が見えている" do
        expect(page).to have_field "user[name]", with: user.name
        expect(page).to have_field "user[profile]", with: user.profile
      end

      context "バリデーションに引っかかった場合" do
        it "編集に失敗すること" do
          fill_in "user[name]", with: "" # 名前が空白
          fill_in "user[profile]", with: "a" * 301 # プロフィールが301文字以上
          find(".btn-primary").click

          # 再度、プロフィール編集画面に戻る
          expect(page).to have_css "h1.profile-edit"

          # エラーが表示されている
          expect(page).to have_css "#error_explanation"
        end
      end
      context "バリデーションを通過した場合" do
        it "編集に成功すること" do
          fill_in "user[name]", with: "I am valid_user"
          fill_in "user[profile]", with: "Hello"
          find(".btn-primary").click

          # ユーザー詳細画面へリダイレクト
          expect(current_path).to eq user_path(user)

          # 成功のフラッシュが表示されている
          expect(page).to have_css ".alert-success"

          # 編集した情報が反映されている
          expect(page).to have_selector ".card-title", text: "valid_user"
          expect(page).to have_selector ".card-text", text: "Hello"
        end
      end
    end
  end
end
