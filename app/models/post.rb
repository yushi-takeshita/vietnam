class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 600 }
  validates :user_id, presence: true
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
