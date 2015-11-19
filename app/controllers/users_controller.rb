class UsersController < ApplicationController
  before_action :if_logged_in, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    @user.password=(params[:user][:password])
    if @user.save
      login_user!
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
