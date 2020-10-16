require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "パスワード再設定の案内メール" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.create_reset_digest
      mail.deliver_now
    end

    after(:all) do
      ActionMailer::Base.deliveries.clear
    end

    it "メールの内容が正しいこと" do
      # ヘッダ
      expect(mail.subject).to eq I18n.t("user_mailer.password_resets.パスワード再設定のご案内")
      expect(mail.from).to eq ["noreply_to_you@example.com"]
      expect(mail.to).to eq [user.email]
      # 本文(.html.erb)
      expect(mail.body.parts[1].body.raw_source).to match user.name
      expect(mail.body.parts[1].body.raw_source).to match I18n.t("user_mailer.password_resets.パスワード再設定ページ")
      # 本文(.text.erb)
      expect(mail.body.parts[0].body.raw_source).to match user.name
      expect(mail.body.parts[0].body.raw_source).to match user.reset_password_token
      expect(mail.body.parts[0].body.raw_source).to match CGI.escape(user.email)
    end

    it "メールが1通増えていること" do
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end
end
