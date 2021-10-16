class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
        # login form, name="session[email]"
    if !user.nil? && user.authenticate(params[:session][:password])
        # login form, name="session[password]"
      if user.activated?
        log_in user #sessions_helper
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
            # if params[:session][:remember_me] == '1'
            #   remember(user)
            # else
            #   forget(user)
            # end
            ## login form, name="session[remember_me]"
        redirect_back_or user # redirect back to memorized or default url
      else
        message = "Account not activated. "
        message += "Check your email for the activation link"
        flash.now[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
