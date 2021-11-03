class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
      # when method is called, symbol (:***) is used in many cases
      # logged_in_user is in Application_Controller
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index   #Get /users
    @users = User.paginate(page: params[:page])
  end 

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

          # log_in @user
          # flash[:success] = "Welcome to the Sample App!"
          # redirect_to @user # get "/users/#{@user.id}"
    else
      render 'new'
    end
  end

  def edit  # Get /users/:id/edit
    @user = User.find(params[:id])
      # => app/views/users/edit.html.erb
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile upload"
      redirect_to @user
    else
        # @user.errors
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # get /users/:id/following
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # get /users/:id/followers
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
        # restricted user data acquisition
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
        # == redirect_to(root_url) unless @user == current_user
        # current_user = #1, => /users/2, @user.id = #2, => x 
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
