# encoding: UTF-8

# Railsチュートリアル9.1.4　複数ウィンドウを使ったログアウトテスト　難しいのでスルー

require "rails_helper"
require "pry-byebug"

RSpec.describe "ユーザー管理機能", type: :system do
  let(:user) { FactoryBot.create(:user, admin: true) } # name: "テストユーザー1", email: "test1@example.com"
  let(:other_user) { FactoryBot.create(:user, name: "テストユーザー2", email: "test2@example.com") }

  before do
    visit root_path
  end

  describe "ユーザー登録機能" do
    context "トップページから登録する場合" do
      context "正しい情報が入力された場合" do
        include_context "正しい情報が入力された場合"

        it_behaves_like "ユーザー登録が成功すること"
        it_behaves_like "ログイン状態であること"
      end
      context "誤った情報が入力された場合" do
        it_behaves_like "ユーザー登録が失敗すること"
      end
    end
    context "会員登録ページから登録する場合" do
      before do
        # ハンバーガーメニューから会員登録ページへ移動する
        find(".navbar-toggler").click
        find(".create-account").click
      end

      context "正しい情報が入力された場合" do
        include_context "正しい情報が入力された場合"

        it_behaves_like "ユーザー登録が成功すること"
        it_behaves_like "ログイン状態であること"
      end
      context "誤った情報が入力された場合" do
        it_behaves_like "ユーザー登録が失敗すること"
      end
    end
  end

  describe "ログイン機能" do
    before do
      # ハンバーガーメニューからログインページへ移動する
      find(".navbar-toggler").click
      find(".login").click
    end

    context "誤った情報が入力された場合" do
      it "ログインに失敗すること" do
        # ログインフォームに何も入力せずにログインボタンをクリックする
        find(".btn-primary").click

        # ログインページに戻る
        expect(page).to have_css "h1.title-login"

        # Flashのエラーが表示される
        expect(page).to have_css(".alert-danger")

        # ページを更新するとFlashが消えている
        visit login_path
        expect(page).to_not have_css(".alert-danger")
      end
    end
    context "正しい情報が入力された場合" do
      context "「次回から自動的にログインする」がチェックされた場合" do
        it "ブラウザを開き直してもログイン状態であること" do
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          find(".form-check-input").check
          find(".btn-primary").click

          # https://github.com/nruth/show_me_the_cookies
          # セッションと期限切れのクッキーのみ削除する
          expire_cookies
          visit root_path

          # トップページのログインフォームが消えている
          expect(page).not_to have_css ".introduction"
        end
      end
      context "「次回から自動的にログインする」がチェックされなかった場合" do
        before do
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          find(".btn-primary").click
        end
        it "ログインに成功すること" do
          # マイページへリダイレクトされる
          expect(current_path).to eq user_path(I18n.locale, user)
        end
        it_behaves_like "ログイン状態であること"
        it "ブラウザを閉じたらログアウトされていること" do
          Capybara.current_session.quit
          visit root_path

          # ログインフォームが表示されている
          expect(page).to have_css ".introduction"
        end
      end
    end
  end

  describe "ログアウト機能" do
    it "ログアウトされていること" do
      login_as(user)

      # ログアウトをクリック
      all(".card-link")[1].click
      expect(current_path).to eq root_path(I18n.locale)

      # ログアウト時のリンクが表示される
      find(".navbar-toggler").click
      expect(page).to have_css ".login"
      expect(page).to have_css ".create-account"

      # トップページのサイト紹介文とログインフォームが表示される
      expect(page).to have_css ".introduction"
    end
  end
  describe "プロフィール表示機能" do
    before do
      (1..15).each do |i|
        FactoryBot.create(:post, created_at: i.day.ago, user: user)
      end
      visit user_path(I18n.locale, user)
    end
    it "10個区切りで投稿がページネーションされていること" do
      within ".posts" do
        expect(all(".card-link").count).to eq 10
      end
    end
    it "上から下へ投稿日時の新しい順に並んでいること" do
      latest_post = user.posts.first
      within ".posts" do
        expect(first(".card-text")).to have_content latest_post.created_at.strftime("%Y/%m/%d")
      end
    end
  end
  describe "プロフィール編集機能" do
    it "ログイン前のユーザーはプロフィールを編集できないこと" do
      visit user_path(I18n.locale, user)

      # 編集のリンクが見えない
      within ".card-body" do
        expect(page).not_to have_css ".card-link.edit-profile-link"
      end

      # 編集ページへアクセスするとログインページに転送される
      visit edit_user_path(I18n.locale, user)
      expect(current_path).to eq login_path(I18n.locale)
      expect(page).to have_css ".alert-danger"
    end
    it "ログイン後であっても他人のプロフィールを編集できないこと" do
      login_as(user)
      visit user_path(I18n.locale, other_user)

      within ".card-body" do
        expect(page).not_to have_css ".card-link.edit-profile-link"
      end

      # 編集ページへアクセスするとトップページに転送される
      visit edit_user_path(I18n.locale, other_user)
      expect(current_path).to eq root_path(I18n.locale)
    end
    context "ユーザーが有効だった場合" do
      before do
        login_as(user)

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
          expect(page).to have_css "h1.title-profile-edit"

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
          expect(current_path).to eq user_path(I18n.locale, user)

          # 成功のフラッシュが表示されている
          expect(page).to have_css ".alert-success"

          # 編集した情報が反映されている
          expect(page).to have_selector ".card-title", text: "valid_user"
          expect(page).to have_selector ".card-text", text: "Hello"
        end
      end
    end
  end

  describe "ユーザー削除機能" do
    context "Admin権限を所有していない場合" do
      it "「アカウントを削除」のリンクが表示されないこと" do
        login_as(other_user)
        expect(page).not_to have_css ".card-link.delete-user"
      end
    end
    context "Admin権限を所有している場合" do
      before { login_as(user) }
      it "自分を削除できない" do
        expect(page).not_to have_css ".card-link.delete-user"
      end

      it "他のユーザーを削除できること" do
        visit user_path(I18n.locale, other_user)
        # 「アカウントを削除」をクリック
        expect(page).to have_css ".card-link.delete-user"
        find(".card-link.delete-user").click

        # OKを選択するとユーザーが1件減る
        expect do
          expect(page.driver.browser.switch_to.alert.text).to eq "このユーザーを完全に削除します。本当によろしいですか？"
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "アカウントを削除しました"
        end.to change { User.count }.by(-1)
      end
    end
  end

  describe "パスワード再設定機能" do
    describe "再設定の案内メール送付処理" do
      before do
        visit new_password_reset_path(I18n.locale)
        fill_in "password_reset[email]", with: email
        find(".btn-primary").click
      end
      context "メールアドレスが無効な場合" do
        let(:email) { "its_wrong@example.com" }
        it "メールアドレス入力画面に戻ること" do
          expect(page).to have_css ".alert-danger"
        end
      end
      context "メールアドレスが有効な場合" do
        let(:email) { user.email }
        it "トップメージに遷移されること" do
          expect(current_path).to eq root_path(I18n.locale)
          expect(page).to have_css ".alert-info"
        end
        it "再設定の案内メールが送信されること" do
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end
      end
    end
    describe "再設定ページへの遷移処理" do
      shared_examples "トップメージに遷移されること" do
        it { expect(current_path).to eq root_path(I18n.locale) }
      end
      before do
        user.create_reset_digest
        visit edit_password_reset_path(I18n.locale, reset_password_token, email: email)
      end
      context "メールアドレスが無効な場合" do
        let(:reset_password_token) { user.reset_password_token }
        let(:email) { "its_wrong@example.com" }
        it_behaves_like "トップメージに遷移されること"
      end
      context "メールアドレスが有効で、トークンが無効な場合" do
        let(:reset_password_token) { "wrong_token" }
        let(:email) { user.email }
        it_behaves_like "トップメージに遷移されること"
      end
      context "メールアドレスもトークンも有効な場合" do
        let(:reset_password_token) { user.reset_password_token }
        let(:email) { user.email }
        it_behaves_like "パスワード再設定ページが表示される"

        describe "パスワードの再設定完了の処理" do
          before do
            fill_in "user[password]", with: password
            fill_in "user[password_confirmation]", with: password_confirmation
            find(".btn-primary").click
          end
          context "パスワードが空の場合" do
            let(:password) { "" }
            let(:password_confirmation) { "" }
            it_behaves_like "エラーが表示されること"
            it_behaves_like "パスワード再設定ページが表示される"
          end
          context "無効なパスワードとパスワード確認の場合" do
            let(:password) { "hogehoge" }
            let(:password_confirmation) { "fugafuga" }
            it_behaves_like "エラーが表示されること"
            it_behaves_like "パスワード再設定ページが表示される"
          end
          context "有効なパスワードとパスワード確認の場合" do
            let(:password) { "new_password" }
            let(:password_confirmation) { "new_password" }
            it "マイページに遷移すること" do
              expect(page).to have_css ".alert-success"
              expect(current_path).to eq user_path(I18n.locale, user)
            end
            it_behaves_like "ログイン状態であること"
          end
        end
      end
    end
  end
end
