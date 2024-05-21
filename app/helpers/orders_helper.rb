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
end
