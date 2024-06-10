class AddCustomerNameToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :customer_name, :string
  end
end
