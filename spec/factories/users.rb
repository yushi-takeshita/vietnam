FactoryBot.define do
  factory :user do
    name { "テストユーザー1" }
    email { "test1@example.com" }
    password { "password" }
    password_confirmation { "password" }
    profile { nil }
    admin { false }
    reset_digest { nil }
    reset_sent_at { nil }
  end
end
