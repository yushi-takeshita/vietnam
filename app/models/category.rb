class Category < ApplicationRecord
  has_ancestry
  has_many :posts, through: :post_categories
  has_many :post_categories, dependent: :destroy
end
