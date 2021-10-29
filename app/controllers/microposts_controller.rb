class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
      # when method is called, symbol (:***) is used in many cases
      # logged_in_user is in Application_Controller
  before_action :correct_user, only: :destroy
  

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url  # => static_pages#home
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
        # request.referrer => previous url
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
          # to check if current_user has the micropost to be destroyed
      redirect_to root_url if @micropost.nil?
    end
    
end
