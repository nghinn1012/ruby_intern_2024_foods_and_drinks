class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :food
  acts_as_paranoid
  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than:
      Settings.validates.order_items.quantity.min}
end
