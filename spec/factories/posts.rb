FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word }
    content { Faker::Lorem.word }
    user
    category
  end
end
