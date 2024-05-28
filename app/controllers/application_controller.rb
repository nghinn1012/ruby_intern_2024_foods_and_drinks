class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale, :check_cart_create

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def admin_user
    redirect_to root_path unless current_user.role.to_sym == :admin
  end

  def check_cart_create
    session[:cart] ||= []
    @cart_items = session[:cart].select do |item|
      item["user_id"] == current_user.id
    end
    return if @cart_items

    flash[:danger] = t("flash_messages.cart_create_error")
    redirect_to root_path
  end

  def delete_all
    session[:cart].reject!{|item| item["user_id"] == current_user.id}
    check_cart_create
  end
end
