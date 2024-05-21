module NotificationHelper
  def check_read notification
    notification.read ? "" : "notification-unread"
  end

  def load_notifications
    current_user.notifications.where(receiver_id: current_user.id).order_by_read
                .order_by_created_at
  end

  def count_noti
    load_notifications.read_filter.count
  end
end
