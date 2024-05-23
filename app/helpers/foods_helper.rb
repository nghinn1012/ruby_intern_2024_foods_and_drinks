module FoodsHelper
  def item_avaiable food
    food.available_item? ? "" : "disabled"
  end

  def load_categories
    @categories.map{|category| [category.name, category.id]}
  end
end
