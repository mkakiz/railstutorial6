class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      store_location
          # to store attempted to access url in session[:forwarding_url] when sesssion (session[:user_id]) is out
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
