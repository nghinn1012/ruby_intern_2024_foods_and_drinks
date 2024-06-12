class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, :configure_permitted_parameters,
                if: :devise_controller?
  def change_password; end

  def update_password
    if current_user.update_with_password(password_update_params)
      redirect_to root_path, notice: t("passwords.updated")
    else
      flash.now[:error] = current_user.errors.full_messages.join(", ")
      render :change, status: :unprocessable_entity
    end
  end

  protected
  def password_update_params
    params.require(:user).permit(:current_password, :password,
                                 :password_confirmation)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:email,
    :first_name, :last_name, :image, :phone, :address])
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name,
    :email, :password, :password_confirmation])
  end

  def update_resource resource, params
    if params[:password].blank? && params[:password_confirmation].blank? &&
       params[:current_password].blank?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end
