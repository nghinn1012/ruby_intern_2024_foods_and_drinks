class AddFieldsToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :order_id, :integer
    add_column :notifications, :status, :string
  end
end
