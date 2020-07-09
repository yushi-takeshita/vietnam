require "rails_helper"
require "byebug"

RSpec.describe "ポストモデル", type: :model do
  let(:user_a) { FactoryBot.create(:user, admin: true) }
  let(:post_a) { user_a.posts.build(content: "Hello", title: "greetings", category_id: 1) }
  # let(:category_a) { Category.create() }

  describe "バリデーション" do
    it "正しい投稿であること" do
      expect(post_a).to be_valid
    end
    describe "user_id" do
      it "空白だとエラーになること" do
        post_a.user_id = nil
        expect(post_a).not_to be_valid
      end
    end
    describe "title" do
      it "空白だとエラーになること" do
        post_a.title = nil
        expect(post_a).not_to be_valid
      end
    end
    describe "content" do
      it "空白だとエラーになること" do
        post_a.content = nil
        expect(post_a).not_to be_valid
      end
      it "601文字以上だとエラーになること" do
        post_a.content = "a" * 601
        expect(post_a).not_to be_valid
      end
      it "投稿日時の新しい順にソートされていること" do
        post_b = user_a.posts.create(content: "Ruby is great", created_at: 10.minutes.ago)
        post_a.update_attribute(:created_at, Time.zone.now)
        expect(post_a).to eq Post.first
      end
      it "検索できるのがcontentカラムのみであること" do
        expect(Post.ransackable_attributes).to eq ["content"]
      end
    end
  end
end
