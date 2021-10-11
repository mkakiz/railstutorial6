module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember 
        #this remember is in user.rb to update remember_digest as hashed(digested) remember_token
    cookies.permanent.signed[:user_id] = user.id  
        #signed = crypted (or restored). user_id = session user id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  def current_user 
        # if session user_id is existed, @current_user is set -> login
        # if signed user_id is in cookie and user is authenticated, @current_user is set -> login
        # otherwise, current_user is nil -> logout
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil? # current_user is not nil, then logged in
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end



end
