class UsersController < ApplicationController
 before_filter :authenticate_user_role! 
 def index
  @users = User.all
end

def show
  @user = User.find(params[:id])
end


def new
  @user = User.new
end

def create
 @user = User.new(params[:user])
 if @user.save
  flash[:notice] = "User created successfully"
  redirect_to @user
else
  render "new"
end
end

def edit
  @user = User.find(params[:id])
end

end
