module FoodsHelper
  def item_avaiable food
    food.available_item? ? "" : "disabled"
  end
end
