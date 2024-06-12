class Users::ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for resource_name, _resource
    flash.now[:notice] = t("confirmation.success")
    new_session_path(resource_name)
  end
end
