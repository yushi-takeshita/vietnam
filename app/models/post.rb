class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 600 }
  validates :user_id, presence: true
  validates :title, presence: true
end
