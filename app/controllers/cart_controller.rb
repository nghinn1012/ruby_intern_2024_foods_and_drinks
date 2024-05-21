class CartController < ApplicationController
  include ApplicationHelper
  include FoodsHelper
  before_action :authentication_user
  before_action :find_food, only: %i(create)
  before_action :pick_cart_item, only: %i(update_quantity destroy)

  def create
    if (existed = find_item_in_cart(@food.id))
      pick_cart_item
      if validate_quantity
        increment_quantity(existed)
        render_create_success
      else
        render_create_error
      end
    elsif validate_quantity_first
      add_new_item(@food)
      respond_to do |format|
        format.html{redirect_to cart_path}
        format.turbo_stream do
          render turbo_stream: [
            update_total_item,
            flash_add_sucess
          ]
        end
      end
    else
      render_create_error
    end
    check_cart_create
  end

  def show; end

  def update_quantity
    if validate_quantity
      @cart_item["food_avaiable_item"] -=
        params[:quantity].to_i - @cart_item["food_quantity"]
      @cart_item["food_quantity"] = params[:quantity].to_i
      check_cart_create
      render_quantity_update_success
    else
      render_error
    end
  end

  def destroy
    session[:cart].delete(@cart_item)
    @cart_items = session[:cart]
    respond_to do |format|
      format.html do
        redirect_to cart_path, notice: t("flash_messages.deleted_successfully")
      end
      format.turbo_stream do
        render turbo_stream: [
          update_total_item,
          turbo_stream.replace("cart_view", partial: "cart/cart_item",
          locals: {cart_items: @cart_items}),
          turbo_stream.append("flash-messages", partial: "layouts/flash",
          locals: {flash: {success: t("flash_messages.deleted_successfully")}})
        ]
      end
    end
  end

  def destroy_all
    delete_all
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          update_total_item,
          turbo_stream.replace("cart_view", partial: "cart/cart_item",
          locals: {cart_items: @cart_items}),
          turbo_stream.append("flash-messages", partial: "layouts/flash",
          locals: {flash: {success: t("flash_messages.deleted_successfully")}})
        ]
      end
    end
  end
  private

  def authentication_user
    return if logged_in?

    redirect_to login_path
  end

  def find_food
    @food = Food.find_by(id: params[:id].to_i)
    return if @food

    flash[:danger] = t("flash_messages.no_food")
    redirect_to root_path
  end

  def find_item_in_cart food_id
    session[:cart].find do |item|
      item["user_id"] == current_user.id && item["food_id"] == food_id
    end
  end

  def add_new_item food
    session[:cart] << {
      "user_id": current_user.id,
      "food_id": food.id,
      "food_quantity": params[:quantity].to_i,
      "food_avaiable_item": food.available_item - params[:quantity].to_i,
      "food_image": url_for(food.image),
      "food_name": food.name,
      "price": food.price
    }
  end

  def update_total_cart_value
    turbo_stream.update("subtotal", view_context
      .subtotal_cart_value(@cart_items))
  end

  def update_total_item_value
    turbo_stream.update("subtotal_item_#{@cart_item['food_id']}",
                        @cart_item["food_quantity"] *
                        @cart_item["price"])
  end

  def update_avaiable_item
    turbo_stream.update("avaiable_item_#{@cart_item['food_id']}",
                        @cart_item["food_avaiable_item"])
  end

  def update_avaiable_cart
    turbo_stream.update("item_avaiable_#{@cart_item['food_id']}",
                        @cart_item["food_avaiable_item"])
  end

  def flash_add_sucess
    turbo_stream.append("flash-messages", partial: "layouts/flash",
    locals: {flash: {success: t("flash_messages.add_to_cart_success")}})
  end

  def flash_error_quantity
    turbo_stream.append("flash-messages", partial: "layouts/flash",
              locals: {flash: {danger: t("flash_messages.quantity_not_found")}})
  end

  def flash_delete
    update_total_item
    turbo_stream.replace("cart_view", partial: "cart/cart_item",
    locals: {cart_items: @cart_items})
    turbo_stream.append("flash-messages", partial: "layouts/flash",
    locals: {flash: {success: t("flash_messages.deleted_successfully")}})
  end

  def render_quantity_update_success
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          update_total_item,
          update_total_item_value,
          update_total_cart_value,
          update_avaiable_cart,
          update_avaiable_item,
          flash_add_sucess
        ]
      end
    end
  end

  def render_error
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          flash_error_quantity,
          update_input_number_if_false
        ]
      end
    end
  end

  def render_create_success
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          update_total_item,
          update_avaiable_item,
          update_avaiable_cart,
          flash_add_sucess
        ]
      end
    end
  end

  def render_create_error
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          update_avaiable_item,
          flash_error_quantity
        ]
      end
    end
  end
end
