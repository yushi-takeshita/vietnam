require "rails_helper"
require "pry-byebug"

RSpec.describe "暮らしに役立つサイト", type: :system do
  before do
    visit useful_pages_path
  end

  it "目次が見えていること" do
    expect(page).to have_selector "h5", text: I18n.t("home.useful_pages.目次")
    expect(page).to have_selector "#section1", text: I18n.t("home.useful_pages.外国人技能実習機構")
    expect(page).to have_selector "#section2", text: I18n.t("home.useful_pages.コミトモ")
  end

  it "項目をクリックすると項目へページ内ジャンプすること" do
    number = rand(0..1)
    all("li")[number].click_link
    expect(current_url).to include "#section#{number + 1}"
  end
end
