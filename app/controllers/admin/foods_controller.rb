class Admin::FoodsController < Admin::BaseAdminController
  layout "admin"
  before_action :load_category, only: %i(create new show edit update)
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :food_not_found

  def index
    @pagy, @foods = pagy(Food.order_by_created_at
                        .search(params[:search])
                        .filter_by_category_ids(params[:category_ids]), items:
                        Settings.number.digit_8)
    @categories = Category.all
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    save_image @food

    if @food.save
      flash[:success] = t("admin.foods.create.success")
      redirect_to admin_foods_path
    else
      flash.now[:danger] = t("admin.foods.create.fail")
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @food.update(food_params)
      flash[:success] = t("admin.foods.update.success")
      redirect_to admin_food_path(id: @food.id)
    else
      flash.now[:danger] = t("admin.foods.update.fail")
      render :edit
    end
  end

  def destroy
    if @food.destroy
      flash[:success] = t("admin.foods.delete.success")
    else
      flash[:danger] = t("admin.foods.delete.fail")
    end
    redirect_to admin_foods_path
  end

  private

  def save_image food
    return if params[:food][:image].blank?

    food.image.attach(params[:food][:image])
  end

  def food_params
    params.require(:food).permit Food::ADMIN_FOODS
  end

  def food_not_found
    flash[:danger] = t "admin.foods.errors.food_not_found"
    redirect_to admin_foods_path
  end

  def load_category
    @categories = Category.all
  end
end
