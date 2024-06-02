class Admin::OrdersController < Admin::BaseAdminController
  layout "admin"
  before_action :find_order, only: %i(show update_status)
  def index
    @pagy, @orders = pagy(filtered_orders.order_by_status, items:
                          Settings.number.digit_8)
  end

  def update_status
    if @order.update(order_params)
      create_noti
      redirect_to admin_orders_path, notice: t("orders.flashes.status_updated")
    else
      redirect_to admin_orders_path, alert: t("orders.flashes.
      status_update_failed")
    end
  end

  def show
    @order_items = @order.order_items.with_deleted
    @foods = Food.with_deleted.items_of_order(@order_items)
  end

  private
  def order_params
    params.require(:order).permit(:status)
  end

  def find_order
    @order = Order.find_by params[:id]
    return if @order

    flash[:danger] = t("orders.no_order")
    redirect_to admin_orders_path
  end

  def create_noti
    Notification.create(
      receiver_id: @order.user_id,
      title: "notifications.order_updated.title",
      content: "notifications.order_updated.content",
      order_id: @order.id,
      status: @order.status,
      read: false
    )
  end
end
