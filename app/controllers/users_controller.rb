class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit, :update, 
            :index, :destroy, :following, :followers
            ]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Check your email for activation link."
      redirect_to root_path #equivalent to user_url(@user)
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Hooray"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Follower"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                      :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "please log in"
        store_location
        redirect_to login_path
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless correct_user?(@user)
      
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
    
  
end
