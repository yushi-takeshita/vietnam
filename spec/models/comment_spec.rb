require "rails_helper"

RSpec.describe "コメント", type: :model do
  describe "バリデーション" do
    let(:comment_a) { FactoryBot.build(:comment) }
    subject { comment_a }
    shared_examples "コメントは無効であること" do
      it { is_expected.to be_invalid }
    end

    it "投稿日時が新しい順にソートされていること" do
      comment_a.save
      sleep 0.5
      FactoryBot.create(:comment)
      expect(Comment.first).to eq comment_a
    end
    context "user_id,post_id,300字以内のコメント内容がそれぞれ存在する場合" do
      it { is_expected.to be_valid }
    end
    context "user_idが空白の場合" do
      before { comment_a.user_id = nil }
      it_behaves_like "コメントは無効であること"
    end
    context "post_idが空白の場合" do
      before { comment_a.post_id = nil }
      it_behaves_like "コメントは無効であること"
    end
    describe "コメント内容" do
      context "空白の場合" do
        before { comment_a.body = nil }
        it_behaves_like "コメントは無効であること"
      end
      context "300字を超える場合" do
        before { comment_a.body = "a" * 301 }
        it_behaves_like "コメントは無効であること"
      end
    end
  end
end
