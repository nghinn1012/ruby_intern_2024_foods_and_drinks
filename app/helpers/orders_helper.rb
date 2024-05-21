module OrdersHelper
  def status_class status
    case status
    when "pending"
      "text-warning"
    when "completed"
      "text-success"
    when "canceled"
      "text-danger"
    else
      "text-secondary"
    end
  end

  def select_status order
    all_statuses = Order.statuses.keys
    case order.status
    when "pending"
      all_statuses
    when "delivering"
      %i(delivering completed canceled)
    when "completed", "canceled"
      [order.status]
    else
      []
    end
  end
end
