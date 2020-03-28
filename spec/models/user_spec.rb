# encoding: UTF-8

require "rails_helper"
require "byebug"

RSpec.describe "ユーザーモデル", type: :model do
  let(:user_a) { FactoryBot.build(:user, admin: true) }

  describe "バリデーション" do
    it "名前、メールアドレス、パスワード、パスワード(再確認)が正しければtrue" do
      valid_user = user_a
      expect(valid_user).to be_valid
    end
    it "メールアドレスが大文字から小文字へ変換されること" do
      upcase_email = "TEST1@EXAMPLE.COM"
      user_a.email = upcase_email
      user_a.save
      expect(upcase_email.downcase).to eq user_a.reload.email
    end
    describe "名前" do
      context "空白の場合" do
        it "エラーメッセージが発生する" do
          user_a.name = nil
          user_a.valid?
          expect(user_a.errors.added?(:name, :blank)).to be_truthy
        end
      end
      context "51文字以上の場合" do
        it "エラーメッセージが発生する" do
          user_a.name = "a" * 51
          user_a.valid?
          expect(user_a.errors.added?(:name, :too_long, count: 50)).to be_truthy
        end
      end
    end
    describe "メールアドレス" do
      context "フォーマットに沿っていない場合" do
        it "エラーメッセージが発生する" do
          # 不適切なメールアドレスを配列
          address = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
          address.each do |invalid_address|
            user_a.email = invalid_address
            user_a.valid?
            expect(user_a.errors.added?(:email, :invalid, value: user_a.email)).to be_truthy
          end
        end
      end
      context "空白の場合" do
        it "エラーメッセージが発生する" do
          user_a.email = nil
          user_a.valid?
          expect(user_a.errors.added?(:email, :blank)).to be_truthy
        end
      end
      context "251文字以上の場合" do
        it "エラーメッセージが発生する" do
          user_a.email = "a" * 251
          user_a.valid?
          expect(user_a.errors.added?(:email, :too_long, count: 250)).to be_truthy
        end
      end
      context "他のアドレスと重複している場合" do
        it "エラーメッセージが発生する" do
          user_a.save
          duplicate_user = user_a.dup
          duplicate_user.email = user_a.email.upcase
          duplicate_user.valid?
          expect(duplicate_user.errors.added?(:email, :taken, value: duplicate_user.email)).to be_truthy
        end
      end
    end
    describe "パスワード" do
      context "空白の場合" do
        it "エラーメッセージが発生する" do
          user_a.password = nil
          user_a.valid?
          expect(user_a.errors.added?(:password, :blank)).to be_truthy
        end
      end
      context "8文字未満の場合" do
        it "エラーメッセージが発生する" do
          user_a.password = "a" * 7
          user_a.valid?
          expect(user_a.errors.added?(:password, :too_short, count: 8)).to be_truthy
        end
      end
      context "パスワード(確認用)と一致しない場合" do
        it "エラーメッセージが発生する" do
          user_a.password_confirmation = "Password"
          user_a.valid?
          expect(user_a.errors.added?(:password_confirmation, :confirmation, attribute: "パスワード")).to be_truthy
        end
      end
    end
    describe "プロフィール" do
      it "301文字以上だとエラーメッセージが発生する" do
        user_a.profile = "a" * 301
        user_a.valid?
        expect(user_a.errors.added?(:profile, :too_long, count: 300)).to be_truthy
      end
    end
  end

  describe "インスタンスメソッド" do
    describe "#remember" do
      it "remember_digestカラムにハッシュ化されたトークンが渡される" do
        user_a.remember_digest = nil
        user_a.remember_token = "hoge"
        expect { user_a.remember }.to change { user_a.remember_digest }.from(nil).to(String)
      end
    end

    describe "#authenticated?" do
      before do
        user_a.remember
      end
      context "remember_digestカラムがnilの場合" do
        it "falseを返す" do
          user_a.remember_digest = nil
          expect(user_a.authenticated?(:remember, user_a.remember_token)).to eq false
        end
      end
      context "remember_digestカラムに値が入っている場合" do
        it "渡されたトークンがダイジェストと一致したらtrueを返す" do
          expect(user_a.authenticated?(:remember, user_a.remember_token)).to eq true
        end
      end
    end

    describe "#forget" do
      it "remember_digestカラムをnilにする" do
        user_a.remember
        expect { user_a.forget }.to change { user_a.remember_digest }.from(String).to(nil)
      end
    end

    describe "#downcase_email" do
      it "メールアドレスが小文字に変換されること" do
        user_a.email = "UPCASE.SAMPLE.COM"
        expect(user_a.downcase_email).to eq "upcase.sample.com"
      end
    end

    describe "#create_reset_digest" do
      subject { Proc.new { user_a.create_reset_digest } }

      it { is_expected.to change { user_a.reset_password_token }.from(nil).to(String) }
      it { is_expected.to change { user_a.reset_digest }.from(nil).to(String) }
      it { is_expected.to change { user_a.reset_sent_at }.from(nil).to(ActiveSupport::TimeWithZone) }
    end

    describe "#password_reset_expired?" do
      let(:user_a) { FactoryBot.build(:user, reset_sent_at: minutes_ago) }
      subject { user_a.password_reset_expired? }

      context "パスワード再設定期限の120分を超えた場合" do
        let(:minutes_ago) { 120.minutes.ago }
        it { is_expected.to eq true }
      end
      context "120分未満の場合" do
        let(:minutes_ago) { 119.minutes.ago }
        it { is_expected.to eq false }
      end
    end
  end
end
