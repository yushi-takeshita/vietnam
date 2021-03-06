class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, :post_id, presence: true
  validates :body, presence: true, length: { maximum: 300 }
  default_scope -> { order(created_at: :desc) }
end
