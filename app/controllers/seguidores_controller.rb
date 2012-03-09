class SeguidoresController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    if (@user != current_user)
      current_user.follow(@user)
    else
      flash[:notice] = "Não é possível seguir a si mesmo!"
    end

    respond_to do |format|
      format.html {render 'show', :layout => false}
    end
  end

  def destroy
     @user = User.find(params[:user_id])
    if (@user != current_user)
      current_user.stop_following(@user)
    else
      flash[:notice] = "Não é possível seguir a si mesmo!"
    end
    respond_to do |format|
      format.html {render :action => :show, :layout => false}
    end
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