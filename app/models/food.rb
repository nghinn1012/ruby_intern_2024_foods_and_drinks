class Food < ApplicationRecord
  belongs_to :categories
  validates :name, presence: true,
    length: {maximum: Settings.validates.foods.name.max_length}
  validates :description, presence: true,
    length: {maximum: Settings.validate.foods.description.max_length}
  validates :price, presence: true,
    numericality: {only_numeric: true, greater_than:
                    Settings.validates.food.price.min, less_than:
                    Settings.validates.food.price.max}
end
