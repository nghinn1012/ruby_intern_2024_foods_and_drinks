class AddConfirmationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    remove_column :users, :confirm_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirm_sent_at
  end
end
