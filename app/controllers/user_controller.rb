# = User Controller
class UserController < ApplicationController
  
  # shows the User with specific ID
  def show
  	@user = User.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
