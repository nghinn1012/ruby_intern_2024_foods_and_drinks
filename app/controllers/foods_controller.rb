class FoodsController < ApplicationController
  def index
    @pagy, @foods = pagy(Food.order_by_created_at, items:
                                                        Settings.number.digit_8)
    @categories = Category.category_sort
    @pagy, @foods = pagy(@foods.filter_by_category_ids(params[:category_ids]),
                         items: Settings.number.digit_8)
  end
end
