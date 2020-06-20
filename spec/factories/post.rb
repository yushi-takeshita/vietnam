FactoryBot.define do
  factory :post do
    title { "greetings" }
    content { "hello" }
    user
  end
end
