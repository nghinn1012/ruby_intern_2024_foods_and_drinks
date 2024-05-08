class Notification < ApplicationRecord
  belongs :users, foreign_key: :receiver_id
  validates :title, presence: true,
    length: {max: Settings.validates.notifications.title.max_length}
  validates :content, presence: true,
    length: {max: Settings.validates.notifications.content.max_length}
end
