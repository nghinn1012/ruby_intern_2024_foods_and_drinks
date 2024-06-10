class NotificationsController < ApplicationController
  before_action :find_notification, only: %i(mark_as_read)

  def index
    @notifications = load_notifications
  end

  def mark_as_read
    if @notification.update(read: true)
      flash[:success] = t("notifications.success.read")
    else
      flash[:danger] = t("notifications.danger.error")
    end
    redirect_back(fallback_location: user_notifications_path)
  end

  def mark_as_read_all
    @notifications = load_notifications
    @notifications.update_all(read: true)
    flash[:success] = t("notifications.success.read_all")
    redirect_back(fallback_location: root_path)
  end

  private

  def find_notification
    @notification = Notification.find_by(id: params[:notification_id])
    return if @notification

    flash[:danger] = t("notifications.danger.not_found")
    redirect_to root_path
  end
end
