require "rails_helper"
require "pry-byebug"

RSpec.describe "掲示板管理機能", type: :system do
  let(:user) { FactoryBot.create(:user, admin: true) }
  let(:post) { FactoryBot.create(:post, user: user) }
  describe "一覧表示機能" do
    before do
      for i in 1..30
        FactoryBot.create(:post, created_at: i.day.ago, user: user)
      end
      visit posts_path(I18n.locale)
    end
    it "25個区切りで投稿がページネーションされていること" do
      within ".posts" do
        expect(all(".card-link").count).to eq 25
      end
    end
    it "上から下へ投稿日時の新しい順に並んでいること" do
      latest_post = user.posts.first
      within ".posts" do
        expect(first(".card-text")).to have_content latest_post.created_at.strftime("%Y/%m/%d")
      end
    end
  end
end
