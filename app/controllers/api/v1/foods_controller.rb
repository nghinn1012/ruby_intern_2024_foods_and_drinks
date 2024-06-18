class Api::V1::FoodsController < Api::V1::ApplicationController
  before_action :authorized, except: %i(index show)
  before_action :set_food, only: %i(show update destroy)

  # GET /api/v1/foods
  def index
    @foods = Food.filter_by_category_ids(params[:category_ids])
                 .filter_by_price(params[:min_price], params[:max_price])
                 .search(params[:search])
                 .order_by_name(params[:sort])
                 .order_by_created_at

    render json: @foods, each_serializer: FoodSerializer, status: :ok
  end

  # GET /api/v1/foods/:id
  def show
    render json: @food, serializer: FoodSerializer, status: :ok
  end

  # POST /api/v1/foods
  def create
    @food = Food.new(food_params)

    if @food.save
      render json: @food, serializer: FoodSerializer, status: :created
    else
      render json: ErrorSerializer.serialize(@food.errors),
             status: :unprocessable_entity
    end
  end

  # PUT /api/v1/foods/:id
  def update
    if @food.update(food_params)
      render json: @food, serializer: FoodSerializer, status: :ok
    else
      render json: ErrorSerializer.serialize(@food.errors),
             status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/foods/:id
  def destroy
    if @food.destroy
      render json: {
        status: true,
        message: I18n.t("api.foods.delete")
      }, status: :ok
    else
      render json: ErrorSerializer.serialize(@food.errors),
             status: :unprocessable_entity
    end
  end

  private

  def set_food
    @food = Food.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: false,
      message: I18n.t("api.foods.not_found")
    }, status: :not_found
  end

  def food_params
    params.require(:food).permit Food::ADMIN_FOODS
  end
end
