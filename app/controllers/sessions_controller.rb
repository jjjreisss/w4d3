class SessionsController < ApplicationController
  before_action :if_logged_in, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(*user_name_and_password)
    if @user
      login_user!
    else
      render :new
    end
  end

  def destroy
    user = current_user

    user.reset_session_token! if user
    session[:session_token] = nil

    redirect_to cats_url
  end

  private
  def user_name_and_password
    [params[:user][:user_name], params[:user][:password]]
  end


end
