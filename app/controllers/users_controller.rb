class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
    # Controls what signed in users can access.
  before_filter :correct_user, only:[:edit, :update]
    # Controls non-signed in to be directed to sing-in page not Index. 
  before_filter :admin_user,  only: [:destroy]
    # Sets destroy privlages to only Admin user. 

  def index
    @users = User.paginate(page: params[:page]) 
      # Linked to will_paginate index.html.erb
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
      # Linked to paginate on show.html.erb
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Thank's for signing up " + @user.name + "!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
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

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end



  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user 
    redirect_to(root_path) unless current_user.admin?
  end


end
