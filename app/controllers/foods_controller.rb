class FoodsController < ApplicationController
  def index
    @foods = filtered_foods
    @pagy, @foods = pagy(@foods, items: Settings.number.digit_8)
    @categories = Category.category_sort
  end

  def show
    @food = Food.find(params[:id]) if params[:id].present?
    respond_to do |format|
      format.html{render(text: "not implemented")}
      format.js
    end
  end

  private

  def filtered_foods
    @foods = Food.all
    @foods = @foods.filter_by_category_ids(params[:category_ids])
                   .filter_by_price(params[:min_price], params[:max_price])
                   .search(params[:search])
                   .filter_by_name(params[:sort])
                   .order_by_created_at
  end
end
