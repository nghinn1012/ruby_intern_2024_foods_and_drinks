class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :category_id, :created_at,
             :updated_at
end
