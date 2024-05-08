class SessionsController < ApplicationController
  before_action :find_user, :authenticate_user, only: %i(create)
  def new; end

  def create
    reset_session
    remember_me @user
    log_in @user
    redirect_to is_admin? ? admin_foods_path : root_path
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  def remember_me user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
  end

  private
  def find_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t("login.errors.user_not_found")
    render :new, status: :unprocessable_entity
  end

  def authenticate_user
    return if @user.authenticate params.dig(:session, :password)

    flash.now[:danger] = t("login.errors.invalid_combination")
    render :new, status: :unprocessable_entity
  end

  def is_admin?
    current_user.role.to_sym == :admin
  end
end
