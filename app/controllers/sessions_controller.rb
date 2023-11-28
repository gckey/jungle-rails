class SessionsController < ApplicationController
  def new
  end

  def create
    # See if a user exists and entered password is correct
    if @user = User.authenticate_with_credentials(params[:email], params[:password])
      # Save user id inside cookies
      session[:user_id] = @user.id
      redirect_to '/'
    else
    # Redirect user to to login form if login failed
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end