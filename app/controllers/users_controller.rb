class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  def show
    @user = User.find(params[:id])
    @my_tv_shows = @user.followed_shows
    @my_movies   = @user.movies
  end
  
  def activation
    @user = User.find_by_confirmation_token!(params[:confirmation_token])
    if @user.activated?
      flash[:error] = "This account has already been confirmed!"
      redirect_to root_path
    else
      @user.activate_user
      sign_in @user
      flash[:success] = "Your account has been confirmed!"
      redirect_to @user
    end
  end

  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end
  
  def create
    if signed_in?
      redirect_to root_path
    else
      @user = User.new(params[:user])
      if @user.save
        @user.send_confirmation_email
        @user.save!
        sign_in @user
        flash[:success] = "Welcome to Revoot!"
        redirect_to @user
      else
        render 'new'
      end
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to users_path, notice: "You can't destroy yourself!"
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end
