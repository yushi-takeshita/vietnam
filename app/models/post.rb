class Post < ApplicationRecord
  has_one_attached :image
  has_many :comments, dependent: :destroy
  belongs_to :category
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 600 }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[content title]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
