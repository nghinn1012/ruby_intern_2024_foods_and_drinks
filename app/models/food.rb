class Food < ApplicationRecord
  ADMIN_FOODS = %i(name description price available_item
  category_id image).freeze
  acts_as_paranoid
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  scope :search, lambda {|term|
    term&.squish! if term

    ransack(name_or_description_cont: term).result
  }
  scope :all_of_category, ->(category_id){where category_id:}
  scope :filter_by_price, lambda {|from, to|
    return if from.blank? && to.blank?

    ransack(price_gteq: from).result.ransack(lt: to).result
  }
  scope :order_by_name, lambda {|type|
    order(name: type) if type.present?
  }
  scope :find_ids, ->(ids){where id: ids}
  scope :order_by_created_at, ->{order(created_at: :desc)}
  scope :order_by_quantity, ->{order(available_item: :desc)}
  scope :filter_by_category_ids, lambda {|category_ids|
    return if category_ids.blank?

    ransack(category_id_in: category_ids).result
  }
  scope :items_of_order, lambda {|order_items|
    where(id: order_items.pluck(:food_id))
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
  def self.ransackable_attributes _auth_object = nil
    %w(available_item category_id created_at deleted_at
      description id name price updated_at)
  end

  def self.ransackable_associations _auth_object = nil
    []
  end
end
