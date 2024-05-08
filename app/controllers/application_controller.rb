class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def admin_user
    redirect_to root_path unless current_user.role.to_sym == :admin
  end
end
