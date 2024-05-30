class AddDeletedColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :deleted_at, :datetime, default: nil
    add_index :order_items, :deleted_at
  end
end
