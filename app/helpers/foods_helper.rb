module FoodsHelper
  def item_avaiable food
    food.available_item? ? "" : "disabled"
  end

  def load_categories
    @categories.map{|category| [category.name, category.id]}
  end

  def subtotal_cart_value cart_items
    subtotal_value = 0

    cart_items.each do |item|
      subtotal_value += item["price"] * item["food_quantity"]
    end

    subtotal_value
  end

  def increment_quantity cart_item
    cart_item["food_avaiable_item"] -= params[:quantity].to_i
    cart_item["food_quantity"] += params[:quantity].to_i
  end

  def pick_cart_item
    @cart_item = find_item_in_cart params[:id].to_i
    return if @cart_item

    flash[:danger] = t("flash_messages.no_cart")
    redirect_to root_path
  end

  def validate_quantity
    params[:quantity].to_i.positive? && params[:quantity].to_i <=
      @cart_item["food_avaiable_item"]
  end

  def validate_quantity_first
    params[:quantity].to_i.positive? && params[:quantity].to_i <=
      @food["available_item"]
  end

  def update_total_item
    turbo_stream.replace("user_cart_items", "<span class='position-absolute
    top-0 start-100 translate-middle badge rounded-pill bg-danger'
    id='user_cart_items'>
    #{count_item @cart_items || 0}
      </span>")
  end

  def update_input_number_if_false
    turbo_stream.replace(
      "input-numb-#{@cart_item['food_id']}",
      "<input type='number' id='input-numb-#{@cart_item['food_id']}' \
      value='#{@cart_item['food_quantity']}' class='form-control input-number' \
      style='width: 5rem'>"
    )
  end
end
