class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_user, :only => [:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      redirect_to root_path, :flash => {:success => "Well done"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path, :flash => {:success => "Content deleted"}
  end


private
  def authenticate_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end
end
