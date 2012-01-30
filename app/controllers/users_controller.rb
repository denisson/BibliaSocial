class UsersController < ApplicationController
  def edit
	@user = current_user
  end

  def update
	@user = User.find(params[:id])
	
	@user.nome = params[:user][:nome]
	@user.foto = params[:user][:foto]
	@user.save
	
	respond_to do |format|
		if @user.errors.empty?
		  format.html  { redirect_to(@user,
						:notice => 'User was successfully updated.') }
		  format.json  { head :no_content }
		else
		  format.html  { render :action => "edit" }
		  format.json  { render :json => @user.errors,
						:status => :unprocessable_entity }
		end
	end
  end

  def show
	@user = User.find(params[:id])
  end

  def mural
	if (current_use != nil)
		@user = current_use
		@atividades = Atividade.where(:user => @user.all_following)
	else
		flash[:notice] = "Você precisa se logar para acessar esta área!"
		redirect_to root
	end
  end
end