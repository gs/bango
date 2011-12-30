class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update]

  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      redirect_to @user, :flash => { :success => "Welcome to Awesome app!" }
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(user_path(@user), :flash => {:success => "Profile updated."})
    else
      @title = "Update user"
      render 'edit'
    end
  end

private
  def authenticate
      deny_access unless signed_in?
  end
end
