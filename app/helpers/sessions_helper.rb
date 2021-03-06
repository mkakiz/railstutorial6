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
      if user && user.authenticated?(:remember, cookies[:remember_token])
                                    # :remember => remember_digest
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    !current_user.nil? # current_user is not nil, then logged in
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
        # redirect back to memorized or default url
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
        # memorize url that user attempted to access
        # request == what user requested
        # original_url == url that user wanted to go
        # request.get == user requested get request (not post, delete, etc)
  end

end
