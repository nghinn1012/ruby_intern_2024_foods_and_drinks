class Order < ApplicationRecord
  belongs_to :users
  has_many :order_items, dependent: :destroy
  enum status: {pending: 0, delivering: 1, completed: 2, canceled: 3}
  enum payment_method: {cash: 0, card: 1, paypal: 2}
  validates :address, presence: true,
    length: {maximum: Settings.validates.orders.address.max_length}
  validates :phone, presence: true,
    length: {maximum: Settings.validates.orders.phone.max_length}
  validates :note, allow_nil: true,
    length: {maxium: Settings.validates.orders.note.max_length}
end
