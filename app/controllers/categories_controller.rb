class CategoriesController < ApplicationController
  before_action :load_category, only: %i(show)
  def show
    @pagy, @foods_of_category = pagy(Food.all_of_category(@category.id), item:
    Settings.number.digit_8)
    return if @foods_of_category

    flash[:error] = t("flash_messages.no_food")
  end

  private

  def load_category
    @category = Category.find_by(id: params[:id].to_i)
    return if @category

    flash[:error] = t("category.errors.category_not_found")
    redirect_to root_path
  end
end
