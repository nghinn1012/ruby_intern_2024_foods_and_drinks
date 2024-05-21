class Order < ApplicationRecord
  acts_as_paranoid
  scope :order_by_created_at, ->{order(created_at: :desc)}
  belongs_to :user, class_name: User.name
  has_many :order_items, dependent: :destroy
  has_many :foods, through: :order_items
  enum status: {pending: 0, delivering: 1, completed: 2, canceled: 3}
  enum payment_method: {cash: 0, card: 1, paypal: 2}
  scope :order_by_status, ->{order(status: :asc)}
  scope :filter_by_status, lambda {|term|
    return if term.blank?

    where(status: statuses[term])
  }
  validates :address, presence: true,
                      length: {maximum:
                      Settings.validates.orders.address.max_length}
  validates :phone, presence: true,
                    length: {maximum:
                    Settings.validates.orders.phone.max_length}
  validates :note, allow_nil: true,
                   length: {maximum: Settings.validates.orders.note.max_length}
end
