require "rails_helper"

RSpec.describe "カテゴリー", type: :model do
  describe "バリデーション" do
    let(:category) { Category.new(params) }
    subject { category }
    context "日本語とベトナム語の名前が存在する場合" do
      let(:params) { { ja_name: "生活の知恵", vi_name: "Sự khôn ngoan của cuộc sống" } }
      it { is_expected.to be_valid }
    end
    context "日本語の名前が空白の場合" do
      let(:params) { { ja_name: "", vi_name: "Sự khôn ngoan của cuộc sống" } }
      it { is_expected.to be_invalid }
    end
    context "ベトナム語の名前が空白の場合" do
      let(:params) { { ja_name: "生活の知恵", vi_name: "" } }
      it { is_expected.to be_invalid }
    end
  end
  describe "Ancestry gem" do
    it "カテゴリ同士が親子関係であること" do
      parent_category = Category.create(ja_name: "質問・相談", vi_name: "Câu hỏi và tham vấn")
      child_category = parent_category.children.create(ja_name: "言葉/文化", vi_name: "Ngôn ngữ và văn hóa")
      expect(child_category.parent).to eq parent_category
    end
  end

  it "カテゴリが削除されると投稿も削除されること" do
    post = FactoryBot.create(:post)
    expect { post.category.destroy }.to change { Post.count }.by(-1)
  end
end
