require "rails_helper"
require "pry-byebug"

RSpec.describe "日本語とベトナム語の言語切替", type: :system do
  before do
    visit root_path
  end
  it "デフォルト表記はベトナム語であること" do
    expect(page).to have_selector "h1", text: "Nếu bạn đang gặp rắc rối ở Nhật bản, chúng ta hãy nói về nó."
  end
  it "ヘッダの言語切替ボタンをクリックすると日本語表記になること" do
    click_link "Việt / 日本語"
    expect(page).to have_selector "h1", text: "日本で困ったら相談しよう。"
  end
end
