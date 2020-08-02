require "rails_helper"

RSpec.describe "ポストモデル", type: :model do
  let(:post_a) { FactoryBot.build(:post) }

  describe "バリデーション" do
    subject { post_a }
    shared_examples "投稿は無効であること" do
      it { is_expected.to be_invalid }
    end

    context "投稿タイトル、投稿内容、ユーザID、カテゴリIDが存在する場合" do
      it { is_expected.to be_valid }
    end
    describe "投稿タイトル" do
      context "投稿タイトルが空白の場合" do
        before { post_a.title = "" }
        it_behaves_like "投稿は無効であること"
      end
      context "投稿タイトルが30字を超えた場合" do
        before { post_a.title = "a" * 31 }
        it_behaves_like "投稿は無効であること"
      end
    end
    describe "投稿内容" do
      context "投稿内容が空白の場合" do
        before { post_a.content = "" }
        it_behaves_like "投稿は無効であること"
      end
      context "投稿内容が600字を超えた場合" do
        before { post_a.content = "a" * 601 }
        it_behaves_like "投稿は無効であること"
      end
    end
    context "ユーザIDが空白の場合" do
      before { post_a.user_id = "" }
      it_behaves_like "投稿は無効であること"
    end
    context "カテゴリIDが空白の場合" do
      before { post_a.category_id = "" }
      it_behaves_like "投稿は無効であること"
    end
  end

  it "検索可能な属性がタイトルと投稿内容のみであること" do
    expect(Post.ransackable_attributes).to eq %w[content title]
  end

  it "投稿日時の新しい順にソートされていること" do
    post_b = post_a.update_attribute(:created_at, 10.minutes.ago)
    post_a.save
    expect(Post.first).to eq post_a
  end

  it "画像が添付できること" do
    post = FactoryBot.create(:post, image: Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/factories/default_image.jpg"), "image/jpg"))
    expect(post.image.attached?).to eq true
  end
end
