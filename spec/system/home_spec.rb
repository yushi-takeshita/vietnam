require "rails_helper"
require "pry-byebug"

RSpec.describe "暮らしに役立つサイト", type: :system do
  describe "目次から参照したいページへジャンプする機能" do
    before do
      visit useful_pages_path
    end

    it "目次が見えていること" do
      expect(page).to have_selector "h5", text: I18n.t("home.useful_pages.目次")
      expect(page).to have_selector "#section1", text: I18n.t("home.useful_pages.外国人技能実習機構")
      expect(page).to have_selector "#section2", text: I18n.t("home.useful_pages.コミトモ")
    end
  end
end
