require "rails_helper"
require "pry-byebug"

RSpec.describe "日本語とベトナム語の言語切替", type: :system do
  before do
    visit root_path
  end
  it "デフォルト表記はベトナム語であること" do
    expect(page).to have_selector "h1", text: "Hãy làm cho cuộc sống ở Nhật bản phong phú hơn"
  end
  it "ヘッダの言語切替ボタンをクリックすると日本語表記になること" do
    find(".navbar-toggler-icon").click
    click_link "Việt / 日本語"
    expect(page).to have_selector "h1", text: "日本での暮らしをもっと豊かに。"
  end
end
