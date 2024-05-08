class AddDeletedAtColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :foods, :delete_at, :deleted_at

    change_column_default :foods, :deleted_at, -> { NULL }

    add_index :foods, :deleted_at
  end
end
