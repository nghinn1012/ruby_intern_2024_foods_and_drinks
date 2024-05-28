class FoodsController < ApplicationController
  before_action :load_food, only: %i(show)
  def index
    @foods = filtered_foods
    @pagy, @foods = pagy(@foods, items: Settings.number.digit_8)
    @categories = Category.category_sort
  end

  def show
    @item_avaiable_add = find_item_avaiable
  end

  def find_item_avaiable
    @cart_item = session[:cart].find do |item|
      item["user_id"] == current_user.id && item["food_id"] == @food.id
    end
    @cart_item.nil? ? @food.available_item : @cart_item["food_avaiable_item"]
  end
  private

  def filtered_foods
    @foods = Food.all.filter_by_category_ids(params[:category_ids])
                 .filter_by_price(params[:min_price], params[:max_price])
                 .search(params[:search])
                 .order_by_name(params[:sort])
                 .order_by_created_at
  end

  def load_food
    @food = Food.find_by id: params[:id]
    return if @food

    flash[:danger] = t("foods.errors.food_not_found")
    redirect_to root_path
  end
end
