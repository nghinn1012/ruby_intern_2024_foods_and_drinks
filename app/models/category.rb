class Category < ApplicationRecord
  has_many :foods, dependent: :destroy
  scope :category_sort, ->{order(name: :asc)}
  validates :name, presence: true,
                    length: {maximum:
                            Settings.validates.categories.name.max_length}
  validates :path,
            length: {maximum: Settings.validates.categories.path.max_length}
end
