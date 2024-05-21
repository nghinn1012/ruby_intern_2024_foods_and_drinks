class CategoriesController < ApplicationController
  before_action :load_category, only: %i(show)
  def show; end

  private

  def load_category
    @category = Food.find_by id: params[:id]
    return if @category

    flash[:error] = t("category.errors.category_not_found")
    redirect_to root_path
  end
end
