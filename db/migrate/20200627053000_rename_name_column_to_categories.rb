class RenameNameColumnToCategories < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :name, :ja_name
    add_column :categories, :vi_name, :string, index: true, null: false
  end
end
