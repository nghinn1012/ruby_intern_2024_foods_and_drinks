class Category < ApplicationRecord
  has_many :food, dependent: :destroy
  validates :name, presence: true,
    length: {max: Settings.validates.categories.max_length}
  validates :path, presence: true,
    length: {max: Settings.validates.categories.max_length}
end
