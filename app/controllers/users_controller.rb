class UsersController < ApplicationController
 before_filter :authenticate_user_role! 
 load_and_authorize_resource

 def index
  @users = User.not_is_admin(current_user)
end

def show
  @user = User.find(params[:id])
  @user_vachanakaaras = @user.user_vachanakaaras
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

def update
  @user = User.find(params[:id])
  if @user.update_attributes(params[:user])
    flash[:notice] = "User updated successfully"
    redirect_to @user
  else
    render "edit"
  end

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

def destroy
  @user = User.find(params[:id])
  @user.destroy
  flash[:error] = "User deleted."
  redirect_to users_path
end

end
