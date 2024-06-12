class ChangeColumnConfirmAt < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :confirm_at, :confirmed_at
  end
end
