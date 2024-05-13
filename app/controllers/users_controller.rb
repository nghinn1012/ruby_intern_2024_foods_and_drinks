class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t(".success")
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    User.new(params[:user]
    .permit(:name, :email, :password, :password_confirmation))
  end
end
