class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

	include Pundit
	# TODO remove after authorization logic is complete
	# after_action :verify_authorized, except: :index
 #  after_action :verify_policy_scoped, only: :index
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    # keep reminding user to change password, if he didn't change the first time
    # explicitly compare value to false, to handle unintentional 'null' values
    if resource.changed_password == false
      flash[:alert] = "You are encouraged to change your password after logging in for the first time!"
      edit_user_registration_path    
    end
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
