require "rails_helper"

RSpec.describe "掲示板管理機能", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }
  let!(:parent_category) { child_category.parent }
  let!(:child_category) { FactoryBot.create(:category, :with_child_category) }

  shared_context "ログインしている場合" do
    before do
      login_as(user)
      visit post_path(I18n.locale, post)
    end
  end
  shared_context "Adminユーザーでログインしている場合" do
    before do
      login_as(admin_user)
      visit post_path(I18n.locale, post)
    end
  end

  describe "投稿一覧・検索ページ" do
    let!(:posts) do
      FactoryBot.create_list(:post, 15, user: user, category: parent_category)
      FactoryBot.create_list(:post, 15, user: user, category: child_category)
    end
    before do
      visit category_path(I18n.locale)
    end
    describe "投稿一覧表示機能" do
      it "15件区切りで投稿がページネーションされていること" do
        within ".posts" do
          expect(all(".card").count).to eq 15
        end
        expect(page).to have_css ".pagination"
      end
      it "上から下へ投稿日時の新しい順に並んでいること" do
        latest_post = Post.first
        within ".posts" do
          expect(first(".card-text")).to have_content latest_post.created_at.strftime("%Y/%m/%d")
        end
      end
      it "検索結果の件数が正しいこと" do
        within ".page_entries_info" do
          expect(page).to have_content Post.count
        end
      end
      it "画像が投稿されてない掲示板のサムネにはデフォルト画像が表示されていること" do
        within ".posts" do
          posts = all(".card")
          posts.each do |post|
            expect(post).to have_css("img[src*='/assets/default_image']")
          end
        end
      end
    end
    describe "投稿検索機能" do
      it "親子カテゴリ検索ができること", js: true do
        within ".parents_list" do
          find(id: parent_category.id.to_s).hover
        end
        within ".children_list" do
          find(id: child_category.id.to_s).click
        end
        # 親カテゴリと子カテゴリで15投稿ずつ作成済み
        expect(all(".card").count).to eq 15
      end
      it "キーワード検索ができること" do
        key_word = Post.first.title
        fill_in "q[title_or_content_cont]", with: key_word
        find(".btn-secondary").click
        expect(all(".card").count).to eq Post.where("title like '%#{key_word}%'")
                                             .or(Post.where("content like '%#{key_word}%'")).count
      end
    end
  end
  describe "掲示板投稿ページ" do
    it "掲示板が投稿できること" do
      login_as(user)

      visit new_post_path
      fill_in "post[title]", with: "VISAの申請について"
      find("option[value='#{parent_category.id}']").select_option
      find("option[value='#{child_category.id}']").select_option
      fill_in "post[content]", with: "注意事項があれば教えて下さい"
      attach_file "post[image]", Rails.root.join("spec/factories/default_image.jpg"), make_visible: true

      # 投稿数が1件増える
      expect { find(".btn-primary").click }.to change { Post.count }.by(1)

      # 掲示板詳細ページへリダイレクトする
      expect(current_path).to eq post_path(I18n.locale, Post.first.id)
      expect(page).to have_css ".alert-success"

      # 掲示板詳細ページに投稿画像が反映されている
      expect(page).to have_css("img[src*='/rails/active_storage/blobs/']")

      # 掲示板一覧ページに投稿画像が反映されている
      visit category_path(I18n.locale)
      within ".posts" do
        expect(page).to have_content "VISAの申請について"
        expect(page).to have_css("img[src*='/rails/active_storage/blobs/']")
      end

      # ユーザプロフィールの投稿一覧に投稿画像が反映されている
      visit user_path(I18n.locale, user)
      expect(page).to have_content "VISAの申請について"
      expect(page).to have_css("img[src*='/rails/active_storage/blobs/']")
    end
  end
  describe "記事詳細ページ" do
    let!(:post) {
      FactoryBot.create(:post, user: user, category: parent_category,
                               image: Rack::Test::UploadedFile
                                 .new(Rails.root.join("spec/factories/default_image.jpg"), "image/jpg"))
    }
    let!(:comment) { FactoryBot.create(:comment, post: post, user: user) }

    before do
      visit post_path(I18n.locale, post)
    end
    describe "詳細表示機能" do
      it "カテゴリーのパンくずリストが表示されていること" do
        within ".breadcrumbs" do
          expect(page).to have_content(/#{parent_category.ja_name} | #{parent_category.vi_name}/)
        end
      end
      it "投稿者の情報が表示されていること" do
        within ".user" do
          expect(page).to have_selector "a[href='/#{I18n.locale}/users/#{post.user.id}']", text: post.user.name
          expect(page).to have_content post.created_at.strftime("%Y/%m/%d %H:%M")
        end
      end
      it "投稿内容や画像が表示されていること" do
        within ".post-wrapper" do
          expect(page).to have_content post.title
          expect(page).to have_content post.content
          expect(page).to have_css("img[src*='/rails/active_storage/blobs/']")
        end
      end
    end
    describe "コメント機能" do
      it "コメント詳細が表示されていること" do
        within "#comment-#{comment.id}" do
          expect(page).to have_content "No.#{comment.id}"
          expect(page).to have_content comment.body
          expect(page).to have_content comment.user.name
        end
      end
      context "ログインしている場合" do
        include_context "ログインしている場合"

        it "コメントを投稿できること" do
          fill_in "comment[body]", with: "good"
          expect { find(".btn-primary").click }.to change { Comment.count }.by(1)
          expect(page).to have_content "good"
        end
        it "コメントに返信できること" do
          within "#comment-#{comment.id}" do
            find(".reply").click
            sleep 0.5
          end
          # コメント入力欄に返信先のコメントナンバーが表示されていること
          expect(page).to have_field Comment.human_attribute_name(:body), with: ">>#{comment.id}\n"

          # 投稿されたコメントナンバーがレスアンカーとしてリンク表示されていること
          expect { find(".btn-primary").click }.to change { Comment.count }.by(1)
          sleep 1.0
          within "#comment-#{Comment.first.id}" do
            expect(page).to have_selector "a[href='#comment-#{comment.id}']", text: ">>#{comment.id}"
          end
        end
      end
      context "Adminユーザーでログインしている場合" do
        it "コメントを削除できること" do
          act_as(user) do
            # 一般ユーザーには削除ボタンが見えないこと
            visit post_path(I18n.locale, post)
            within "#comment-#{comment.id}" do
              expect(page).not_to have_link "削除"
            end
          end

          login_as(admin_user)
          visit post_path(I18n.locale, post)
          within "#comment-#{comment.id}" do
            expect(page).to have_link "削除"
          end
          expect { click_link "削除" }.to change { Comment.count }.by(-1)
        end
      end
    end
    describe "掲示板削除機能" do
      shared_examples "削除メニューが表示されていないこと" do
        it { expect(page).not_to have_css "p.menu" }
      end
      shared_examples "掲示板が削除できること" do
        it {
          within "p.menu" do
            click_link I18n.t("posts.show.削除")
          end
          expect(page).to have_selector ".modal-body", text: I18n.t("posts.show.本当にこの掲示板を削除してよろしいですか？")
          expect { click_button I18n.t("posts.show.はい") }.to change { Post.count }.by(-1)
          expect(current_path).to eq category_path(I18n.locale) # 投稿一覧・検索ページ
        }
      end

      context "未ログインユーザーの場合" do
        it_behaves_like "削除メニューが表示されていないこと"
      end
      context "投稿主以外のログインユーザーの場合" do
        let(:other_user) { FactoryBot.create(:user) }
        before do
          login_as(other_user)
          visit post_path(I18n.locale, post)
        end
        it_behaves_like "削除メニューが表示されていないこと"
      end
      context "投稿主の場合" do
        include_context "ログインしている場合"
        it_behaves_like "掲示板が削除できること"
      end
      context "Adminユーザーでログインしている場合" do
        include_context "Adminユーザーでログインしている場合"
        before do
          login_as(admin_user)
          visit post_path(I18n.locale, post)
        end
        it_behaves_like "掲示板が削除できること"
      end
    end
    describe "掲示板編集機能" do
      context "未ログインユーザーの場合" do
        it "ログイン画面へ誘導されること" do
          visit edit_post_path(I18n.locale, post)
          expect(current_path).to eq login_path(I18n.locale)
          expect(page).to have_content I18n.t("users.new.flash.ログインしてください")
        end
      end
      context "投稿主以外のログインユーザーの場合" do
        let(:other_user) { FactoryBot.create(:user) }
        before do
          login_as(other_user)
          visit post_path(I18n.locale, post)
        end
        it "トップページへ誘導されること" do
          visit edit_post_path(I18n.locale, post)
          expect(current_path).to eq root_path(I18n.locale)
        end
      end
      context "投稿主の場合" do
        include_context "ログインしている場合"
        context "投稿後10分を超えている場合" do
          it "編集ページへアクセスできないこと" do
            travel_to(post.created_at + 601) do
              visit edit_post_path(I18n.locale, post)
              expect(current_path).to eq category_path(I18n.locale)
              expect(page).to have_content I18n.t("posts.edit.投稿後10分以内であれば修正が可能です")
            end
          end
        end
        context "投稿後10分以内の場合" do
          it "掲示板が編集できること" do
            travel_to(post.created_at + 600) do
              visit edit_post_path(I18n.locale, post)
              expect(page).not_to have_field Post.human_attribute_name(:title), with: "編集しました"
              fill_in "post[title]", with: "編集しました"
              find(".btn-primary").click
              expect(current_path).to eq post_path(I18n.locale, post)
              expect(page).to have_content "編集しました"
            end
          end
        end
      end
      context "Adminユーザーでログインしている場合" do
        include_context "Adminユーザーでログインしている場合"

        it "投稿時間に関わらず掲示板の編集ができること" do
          travel_to(post.created_at + 601) do
            visit edit_post_path(I18n.locale, post)
            expect(page).not_to have_field Post.human_attribute_name(:title), with: "編集しました"
            fill_in "post[title]", with: "編集しました"
            find(".btn-primary").click
            expect(current_path).to eq post_path(I18n.locale, post)
            expect(page).to have_content "編集しました"
          end
        end
      end
    end
  end
end
