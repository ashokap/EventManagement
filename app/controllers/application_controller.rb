class ApplicationController < ActionController::Base
  include Pundit
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #this line is to restrict access to other pages within application for un authorized user
  before_action :authenticate_user!
  
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

   flash[:error] = "You cannot perform #{exception.query} action on #{policy_name}."
   redirect_to(request.referrer || root_path)
  end
  
end
