require "rails_helper"

RSpec.describe "I18n", type: :request do
  context "ロケール指定が無い場合" do
    it "デフォルトロケールがベトナム語であること" do
      get "/"
      expect(I18n.locale).to eq :vi
    end
  end
  context "ロケール指定が有る場合" do
    it "正しいロケールは反映されること" do
      get "/", :params => { locale: "ja" }
      expect(I18n.locale).to eq :ja
    end
  end
end
