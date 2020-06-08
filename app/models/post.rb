class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 280 }
  validates :user_id, presence: true
end
