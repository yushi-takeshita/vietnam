class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 600 }
  validates :user_id, presence: true
end
