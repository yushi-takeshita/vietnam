require "rails_helper"
require "pry-byebug"

RSpec.describe "暮らしに役立つサイト", type: :system do
  before do
    visit useful_pages_path
  end

  it "目次が見えていること" do
    sleep 0.5
    expect(page).to have_selector "h2", text: I18n.t("home.useful_pages.目次")
    expect(page).to have_selector "#section0", text: I18n.t("home.useful_pages.外国人技能実習機構")
    expect(page).to have_selector "#section1", text: I18n.t("home.useful_pages.コミトモ")
  end

  it "項目をクリックすると項目へページ内ジャンプすること" do
    number = rand(0..1)
    within ".menu" do
      all("li")[number].click_link
    end
    # アンカーがURLに含まれていること
    expect(current_url).to include "#section#{number}"
  end
end
