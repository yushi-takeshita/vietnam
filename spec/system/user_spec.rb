# encoding: UTF-8

require "rails_helper"
require "byebug"

RSpec.describe "ユーザー管理機能", type: :system do
  before do
    visit root_path
  end

  describe "ユーザー登録機能" do
    before do
      find(".navbar-toggler").click
      click_link "会員登録"
    end
    it "正しい情報が入力された場合" do
      fill_in "ハンドルネーム", with: "テストユーザー"
      fill_in "メールアドレス", with: "test1@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード(確認用)", with: "password"
      click_button "登録する"

      # 個々のユーザー詳細画面へ遷移
      @user = User.find_by(email: "test1@example.com")
      expect(current_path).to eq user_path(@user)
      expect(page).to have_content @user.name

      # 登録成功のフラッシュが表示されている
      expect(page).to have_css ".alert-success"

      # ログインされている
      # ヘッダーにマイページが追加
      find(".navbar-toggler").click
      expect(page).to have_css ".mypage"

      # 未ログイン時のリンクが除外
      expect(page).not_to have_css ".login"
      expect(page).not_to have_css ".create-account"
    end

    it "誤った情報が入力された場合" do
      fill_in "ハンドルネーム", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      fill_in "パスワード(確認用)", with: ""

      # 登録ボタンをクリックしてもユーザーは増えない
      expect do
        click_button "登録する"
      end.to_not change(User, :count)

      # 再度、会員登録画面に戻る
      expect(page).to have_content "会員情報の入力"

      # エラーが表示されている
      expect(page).to have_css "#error_explanation"
    end
  end

  describe "ログイン機能" do
    before do
      @user = FactoryBot.create(:user, email: "a@example.com")
      find(".navbar-toggler").click
      click_link "ログイン"
    end

    it "正しい情報が入力された場合" do
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      click_button "ログイン"

      # ユーザー詳細画面へリダイレクト
      expect(current_path).to eq user_path(@user)

      # ヘッダーにマイページが表示
      find(".navbar-toggler").click
      expect(page).to have_css ".mypage"

      # 未ログイン時のリンクが除外
      expect(page).not_to have_css ".login"
      expect(page).not_to have_css ".create-account"

      # トップページの紹介文とログインフォームが除外
      visit root_path
      expect(page).not_to have_css ".introduction"
    end

    it "誤った情報が入力された場合" do
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      click_button "ログイン"

      # Flashのエラーが表示される
      expect(page).to have_css(".alert-danger")
      # ページを更新するとFlashが消えている
      visit login_path
      expect(page).to_not have_css(".alert-danger")
    end
  end

  describe "ログアウト機能" do
    it do
      valid_login
      click_link "ログアウト"

      # トップページへリダイレクト
      expect(current_path).to eq root_path

      # 未ログイン時のリンクが表示
      find(".navbar-toggler").click
      expect(page).to have_css ".login"
      expect(page).to have_css ".create-account"
    end
  end

  describe "プロフィール編集機能" do
    before do
      find(".navbar-toggler").click
      click_link "ログイン"
      valid_login
      click_link "編集"
    end

    it "無効な情報が入力された場合" do
      fill_in "ハンドルネーム", with: ""
      fill_in "プロフィール", with: "a" * 301
      click_button "更新する"

      # 再度、プロフィール編集画面に戻る
      expect(page).to have_content "プロフィールの編集"

      # エラーが表示されている
      expect(page).to have_css "#error_explanation"
    end
  end
end
