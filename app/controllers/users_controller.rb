class UsersController < ApplicationController
  before_action :setup_user,only: [:show,:edit,:update]
  before_action :logged_in_user,only: [:index,:edit,:update]
  before_action :correct_user,only: [:edit,:update]
  before_action :admin_user,only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def setup_user
    @user = User.find_by(id: params[:id])
    redirect_to root_url unless @user.activated?
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


end
