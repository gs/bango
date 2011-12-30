class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                            params[:session][:password])
    if user.nil?
      @title = "Sign in"
      flash.now[:error] = "Invalid email/password"
      render :new
    else

    end
  end

  def destroy

  end
end
