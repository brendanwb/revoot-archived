class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  def show
    if User.exists?(:confirmation_token => params[:id])
      @user = User.find_by_confirmation_token!(params[:id])
      @user.activate_user
      sign_in @user
      flash[:success] = "Your Account has been Confirmed!"
      redirect_to @user
    else
      @user = User.find(params[:id])
    end
    @my_tv_shows = @user.followed_shows
    @my_movies   = @user.movies
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
        @user.state = "pending"
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
  
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end
