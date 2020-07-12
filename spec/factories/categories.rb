FactoryBot.define do
  factory :category do
    ja_name { "質問・相談" }
    vi_name { "Câu hỏi và tham vấn" }
    ancestry { nil }
    trait :with_child_category do |f|
      f.parent { create(:category) }
      ja_name { "言葉/文化" }
      vi_name { "Ngôn ngữ và văn hóa" }
    end
  end
end
