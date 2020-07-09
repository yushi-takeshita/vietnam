class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_ancestry

  validates :ja_name, :vi_name, presence: true
end
