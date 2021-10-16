class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
                             # params[:email] => get email from activation URL
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
                                      # authenticated? => confirm token before and after digested
                                      # /account_activations/:id/edit = /account_activations/<token>/edit 
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
