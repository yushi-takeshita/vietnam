require "rails_helper"

RSpec.describe "掲示板管理機能", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:parent_category) { child_category.parent }
  let!(:child_category) { FactoryBot.create(:category, :with_child_category) }

  describe "投稿一覧・検索ページ" do
    let!(:posts) {
      FactoryBot.create_list(:post, 15, user: user, category: parent_category)
      FactoryBot.create_list(:post, 15, user: user, category: child_category)
    }
    before do
      visit category_path(I18n.locale)
    end
    describe "投稿一覧表示機能" do
      it "25個区切りで投稿がページネーションされていること" do
        within ".posts" do
          expect(all(".card").count).to eq 25
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
          find_by_id("#{parent_category.id}").hover
        end
        within ".children_list" do
          find_by_id("#{child_category.id}").click
        end
        # 親カテゴリと子カテゴリで15投稿ずつ作成済み
        expect(all(".card").count).to eq 15
      end
      it "キーワード検索ができること" do
        key_word = Post.first.title
        fill_in "q[title_or_content_cont]", with: key_word
        find(".btn-secondary").click
        expect(all(".card").count).to eq Post.where("title like '%#{key_word}%'").or(Post.where("content like '%#{key_word}%'")).count
      end
    end
  end
  describe "記事投稿ページ" do
    it "記事が投稿できること" do
      login_as(user)

      visit new_post_path
      fill_in "post[title]", with: "VISAの申請について"
      find("option[value='#{parent_category.id}']").select_option
      find("option[value='#{child_category.id}']").select_option
      fill_in "post[content]", with: "注意事項があれば教えて下さい"
      attach_file "post[image]", "#{Rails.root}/spec/factories/default_image.jpg", { make_visible: true }

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
end
