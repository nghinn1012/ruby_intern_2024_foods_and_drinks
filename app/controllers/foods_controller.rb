class FoodsController < ApplicationController
  before_action :load_food, only: %i(show)
  def index
    @foods = filtered_foods
    @pagy, @foods = pagy(@foods, items: Settings.number.digit_8)
    @categories = Category.category_sort
  end

  def show; end

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
