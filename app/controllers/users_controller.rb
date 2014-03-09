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

def assign_new_vachanakaaras
  @user = User.find(params[:id])
  @vachanakaaras = Vachanakaara.not_in_user_vachanakaaras
end

def assign_vachanakaaras
  @user = User.find(params[:id])
  User.assign_vachanakaara(@user, params[:vachanakaaras])
  flash[:notice] = "Vachanakaara assignment for user successfull"
  redirect_to @user

end

end
