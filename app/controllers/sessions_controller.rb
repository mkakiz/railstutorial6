class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
        # login form, name="session[email]"
    if !user.nil? && user.authenticate(params[:session][:password])
        # login form, name="session[password]"
      log_in user #sessions_helper
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          # if params[:session][:remember_me] == '1'
          #   remember(user)
          # else
          #   forget(user)
          # end
          ## login form, name="session[remember_me]"
      redirect_to user # get "/users/#{@user.id}"
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
