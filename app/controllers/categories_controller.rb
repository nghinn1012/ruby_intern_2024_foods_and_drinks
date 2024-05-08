class CategoriesController < ApplicationController
  def show
    @category = Category.find params[:id]
    @foods_of_category = Food.all_of_category params[:id]
  end
end
