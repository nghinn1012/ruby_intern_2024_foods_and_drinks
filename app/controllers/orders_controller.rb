class OrdersController < ApplicationController
  include OrdersHelper
  include FoodsHelper
  before_action :find_order, only: %i(show destroy)
  load_and_authorize_resource
  def new
    @order = current_user.orders.build
    check_cart_create
    @total_price = subtotal_cart_value(@cart_items)
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build order_params
      @order.amount = calculate_total_price(@cart_items)
      if @order.save
        save_order
        noti_create_order
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => e
      flash[:danger] = e.message
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @pagy, @orders = pagy(current_user.orders.order_by_created_at, items:
                          Settings.number.digit_8)
  end

  def show
    @order_items = @order.order_items.with_deleted
    @foods = Food.with_deleted.where(id: @order_items.pluck(:food_id))
  end

  def destroy
    if @order.status.to_sym != :pending
      flash[:danger] = t("orders.flashes.delete_fail")
    elsif @order.destroy
      noti_cancel_order
      flash[:info] = t("orders.flashes.delete_success")
    else
      flash[:danger] = t("orders.flashes.delete_fail")
    end

    redirect_to order_history_path
  end
  private

  def save_order
    save_order_items
    update_food_availability
    flash[:success] = t("orders.flashes.create_success")
    delete_all
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t("orders.flashes.no_order")
    redirect_to order_history_path
  end

  def order_params
    params.require(:order).permit(:customer_name, :status, :address, :phone,
                                  :note, :payment_method)
  end

  def save_order_items
    order_items = @cart_items.map do |item|
      @order.order_items.build(
        food_id: item["food_id"],
        quantity: item["food_quantity"],
        price: item["price"],
        total: item["price"] * item["food_quantity"]
      )
    end

    OrderItem.import(order_items)
  end

  def calculate_total_price cart_items
    cart_items.sum{|item| item["price"] * item["food_quantity"]}
  end

  def update_food_availability
    food_ids = @cart_items.map{|item| item["food_id"]}
    foods = Food.find_ids(food_ids).index_by(&:id)
    @cart_items.each do |item|
      food = foods[item["food_id"]]
      new_quantity = food.available_item - item["food_quantity"]
      item["food_avaiable_item"] = new_quantity
      food.update(available_item: new_quantity)
    end
  end

  def create_notification type, status
    Notification.create(
      receiver_id: @order.user_id,
      title: "notifications.order_#{type}.title",
      content: "notifications.order_#{type}.content",
      order_id: @order.id,
      status:,
      read: false
    )
  end

  def noti_create_order
    create_notification("created", @order.status)
  end

  def noti_cancel_order
    create_notification("canceled", "canceled")
  end
end
