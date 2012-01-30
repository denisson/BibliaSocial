class SeguidoresController < ApplicationController

  def new
	@user = User.find(params[:user_id])
	if (@user != current_user)
		current_user.follow(@user)
	else
		flash[:notice] = "Não é possível seguir a si mesmo!"
	end
	
	redirect_to user_path(@user)
  end

  def index
	@user = User.find(params[:user_id])
	@users = @user.followers
  end
  
  def seguindo
	@user = User.find(params[:user_id])
	@users = @user.all_following
	p @users.inspect
	render :action => "index"
  end

end