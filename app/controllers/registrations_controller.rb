class RegistrationsController < Devise::RegistrationsController
  before_action :resource_name, :configure_permitted_parameters

  def resource_name
    :user
  end

  protected

  def sign_up_params
    # only customers are allowed to sign up
    devise_parameter_sanitizer.sanitize(:sign_up).merge type: "Customer"
  end

  # adding the 'name' attribute to devise params
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end