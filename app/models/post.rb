class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 280 }
end
