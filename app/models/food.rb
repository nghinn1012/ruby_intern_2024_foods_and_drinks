class Food < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  scope :order_by_created_at, ->{order(created_at: :desc)}
  scope :filter_by_category_ids, lambda {|category_ids|
    return if category_ids.blank?

    joins(:category).where(categories: {id: category_ids}).distinct
  }
  validates :name, presence: true,
    length: {maximum: Settings.validates.foods.name.max_length}
  validates :description, presence: true,
    length: {maximum: Settings.validates.foods.description.max_length}
  validates :price, presence: true,
    numericality: {only_numeric: true, greater_than:
                    Settings.validates.foods.price.min, less_than:
                    Settings.validates.foods.price.max}
  delegate :name, to: :category, prefix: true
end
