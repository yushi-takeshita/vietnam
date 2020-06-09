class AddColumnToPost < ActiveRecord::Migration[5.2]
  def change
    add_reference :posts, :user, foreign_key: true
    add_index :posts, [:user_id, :created_at]
  end
end
