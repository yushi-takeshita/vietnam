# coding: utf-8

require "rails_helper"
require "byebug"

RSpec.describe "ユーザー管理機能", type: :system do
  describe "ユーザー登録機能" do
    before do
      visit new_user_path
    end
    it "正しい情報が入力された場合" do
      fill_in "ハンドルネーム", with: "ユーザーA"
      fill_in "メールアドレス", with: "a@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード(確認用)", with: "password"

      # 登録ボタンをクリックするとユーザーが1件増える
      expect {
        click_button "登録する"
      }.to change(User, :count).by(1)

      # ホーム画面に戻る
      expect(current_path).to eq root_path

      # 登録成功のフラッシュが表示されている
      expect(page).to have_css ".alert-success"
    end

    it "誤った情報が入力された場合" do
      fill_in "ハンドルネーム", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      fill_in "パスワード(確認用)", with: ""

      # 登録ボタンをクリックしてもユーザーは増えない
      expect {
        click_button "登録する"
      }.to_not change(User, :count)

      # 再度、会員登録画面に戻る
      expect(page).to have_content "会員情報の入力"

      # エラーが表示されている
      expect(page).to have_css "#error_explanation"
    end
  end
end
