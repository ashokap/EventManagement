class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #this line is to restrict access to other pages within application for un authorized user
  before_action :authenticate_user!
end
