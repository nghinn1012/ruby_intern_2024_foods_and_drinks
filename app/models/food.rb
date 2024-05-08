class Food < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  scope :search, lambda {|term|
    return if term.blank?

    where("foods.name LIKE :term OR foods.description LIKE :term", term:
       "%#{term}%")
  }
  scope :all_of_category, ->(category_id){where category_id:}
  scope :filter_by_price, lambda {|from, to|
    return if from.blank? || to.blank?

    where("price >= ? AND price <= ?", from, to)
  }
  scope :filter_by_name, lambda {|type|
    return if type.blank?

    order(name: type)
  }
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
