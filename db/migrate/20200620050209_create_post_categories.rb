class CreatePostCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :post_categories do |t|
      t.references :post, null: false
      t.references :category, null: false
      t.timestamps
    end
  end
end
