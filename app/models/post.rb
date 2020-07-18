class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 600 }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }

  def self.ransackable_attributes(auth_object = nil)
    %w[content title]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
