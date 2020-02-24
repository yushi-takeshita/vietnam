# coding: utf-8

require "rails_helper"
require "byebug"

RSpec.describe "ユーザーモデル", type: :model do
  let(:user_a) { FactoryBot.build(:user) }

  describe "バリデーション" do
    it "正しい名前、メールアドレス、パスワード、パスワード(再確認)だと有効" do
      valid_user = user_a
      expect(valid_user).to be_valid
    end
    it "名前が空白だと無効" do
      user_a.name = nil
      user_a.valid?
      expect(user_a.errors.added?(:name, :blank)).to be_truthy
    end
    it "名前が51文字以上だと無効" do
      user_a.name = "a" * 51
      user_a.valid?
      expect(user_a.errors.added?(:name, :too_long, count: 50)).to be_truthy
    end
    it "メールアドレスがフォーマットに沿っていなければ無効" do
      # 不適切なメールアドレスを配列
      address = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      address.each do |invalid_address|
        user_a.email = invalid_address
        user_a.valid?
        expect(user_a.errors.added?(:email, :invalid, value: user_a.email)).to be_truthy
      end
    end
    it "メールアドレスが大文字から小文字へ変換されていれば有効" do
      user_a.email = "HOGE@FUGA.COM"
      user_a.save!
      expect(user_a.email).to eq "hoge@fuga.com"
    end
    it "メールアドレスが空白だと無効" do
      user_a.email = nil
      user_a.valid?
      expect(user_a.errors.added?(:email, :blank)).to be_truthy
    end
    it "メールアドレスが251文字以上だと無効" do
      user_a.email = "a" * 251
      user_a.valid?
      expect(user_a.errors.added?(:email, :too_long, count: 250)).to be_truthy
    end
    it "メールアドレスが他と重複だと無効" do
      user_a.save
      duplicate_user = user_a.dup
      duplicate_user.email = user_a.email.upcase
      duplicate_user.valid?
      expect(duplicate_user.errors.added?(:email, :taken, value: duplicate_user.email)).to be_truthy
    end
    it "パスワードが空白だと無効" do
      user_a.password = nil
      user_a.valid?
      expect(user_a.errors.added?(:password, :blank)).to be_truthy
    end
    it "パスワードが8文字未満だと無効" do
      user_a.password = "a" * 7
      user_a.valid?
      expect(user_a.errors.added?(:password, :too_short, count: 8)).to be_truthy
    end
    it "パスワード(確認用)と一致しなければ無効" do
      user_a.password_confirmation = "Password"
      user_a.valid?
      expect(user_a.errors.added?(:password_confirmation, :confirmation, attribute: "パスワード")).to be_truthy
    end
  end
end
