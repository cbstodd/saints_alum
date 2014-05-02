class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy 

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy 
    redirect_to root_path 
  end

  def reply

  end

  def edit
  end

  private
    def correct_user 
      @micropost = Micropost.find_by_id(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end

end