class Order < ApplicationRecord
  acts_as_paranoid
  belongs_to :user, class_name: User.name
  has_many :order_items, dependent: :destroy
  has_many :foods, through: :order_items
  enum status: {pending: 0, delivering: 1, completed: 2, canceled: 3}
  enum payment_method: {cash: 0, card: 1, paypal: 2}
  scope :order_by_created_at, ->{order(created_at: :desc)}
  scope :order_by_status, ->{order(status: :asc)}
  scope :search_by_attributes, lambda {|term|
    return if term.blank?

    ransack(customer_name_or_note_or_address_cont: term).result
  }
  scope :filter_by_status, lambda {|statuses|
    return if statuses.blank?

    ransack(status_in: statuses).result
  }
  ransacker :created_at, type: :date do
    Arel.sql("date(created_at)")
  end
  validates :address, presence: true,
                      length: {maximum:
                      Settings.validates.orders.address.max_length}
  validates :phone, presence: true,
                    length: {maximum:
                    Settings.validates.orders.phone.max_length}
  validates :note, allow_nil: true,
                   length: {maximum: Settings.validates.orders.note.max_length}
  def self.ransackable_attributes _auth_object = nil
    %w(user_id note address phone
    status amount payment_method customer_name created_at)
  end

  def self.ransackable_associations _auth_object = nil
    []
  end
end
