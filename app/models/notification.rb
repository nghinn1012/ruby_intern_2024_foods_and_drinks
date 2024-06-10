class Notification < ApplicationRecord
  belongs_to :receiver, class_name: User.name
  scope :user_noti, ->(receiver_id){where receiver_id:}
  scope :read_filter, ->{where read: false}
  scope :order_by_read, ->{order(read: :asc)}
  scope :order_by_created_at, ->{order(created_at: :desc)}
  validates :title, presence: true,
    length: {maximum: Settings.validates.notifications.title.max_length}
  validates :content, presence: true,
    length: {maximum: Settings.validates.notifications.content.max_length}
end
