FactoryBot.define do
  sequence(:name, "user-1")
  factory :user do
    name
    email { "#{name}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    profile { nil }
    admin { false }
    reset_digest { nil }
    reset_sent_at { nil }
  end
end
