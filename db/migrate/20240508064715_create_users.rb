class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.boolean :is_actived, default: false
      t.string :phone
      t.string :address
      t.integer :role, default: 1
      t.string :password_digest, null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :confirm_token
      t.datetime :confirm_at
      t.datetime :confirm_sent_at

      t.timestamps
    end

    create_table :categories do |t|
      t.string :name, null: false
      t.string :parent_id
      t.string :path

      t.timestamps
    end

    create_table :foods do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price
      t.integer :available_item
      t.datetime :delete_at

      t.timestamps
    end

    create_table :notifications do |t|
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.text :content
      t.boolean :read

      t.timestamps
    end

    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :note
      t.string :address
      t.string :phone
      t.integer :status, default: 1
      t.integer :amount
      t.integer :payment_method, default: 0
      t.datetime :delete_at

      t.timestamps
    end

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.decimal :total

      t.timestamps
    end
  end
end
