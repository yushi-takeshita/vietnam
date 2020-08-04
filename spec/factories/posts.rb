FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word }
    content { Faker::Lorem.word }
    image { nil }
    user
    category
  end
end
