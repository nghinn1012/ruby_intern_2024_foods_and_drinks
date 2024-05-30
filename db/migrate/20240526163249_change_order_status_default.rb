class ChangeOrderStatusDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :orders, :status, -> {0}
  end
end
