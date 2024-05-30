class Food < ApplicationRecord
  ADMIN_FOODS = %i(name description price available_item
  category_id image).freeze
  acts_as_paranoid
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  scope :search, lambda {|term|
    return if term.blank?

    where("foods.name LIKE :term OR foods.description LIKE :term", term:
       "%#{term}%")
  }
  scope :all_of_category, ->(category_id){where category_id:}
  scope :filter_by_price, lambda {|from, to|
    return if from.blank? && to.blank?

    if to.blank?
      where("price >= ?", from)
    elsif from.blank?
      where("price <= ?", to)
    else
      where("price >= ? AND price <= ?", from, to)
    end
  }
  scope :order_by_name, lambda {|type|
    order(name: type) if type.present?
  }
  scope :order_by_created_at, ->{order(created_at: :desc)}
  scope :filter_by_category_ids, lambda {|category_ids|
    return if category_ids.blank?

    joins(:category).where(categories: {id: category_ids}).distinct
  }
  scope :find_ids, ->(ids){where id: ids}
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
