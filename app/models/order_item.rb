class OrderItem < ApplicationRecord
  belongs_to :orders, dependent: :destroy
  belongs_to :foods
  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than:
      Settings.validates.order_items.quantity.min}
end
