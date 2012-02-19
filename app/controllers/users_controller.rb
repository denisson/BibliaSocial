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
	@filtro =  params[:filtro]
	if @filtro == nil
		@itens = @user.atividades.map(&:item)
	else
		@itens = @filtro.constantize.where(:user_id => @user)
	end
  end

  def mural
	if (current_user != nil)
		@user = current_user
		@filtro =  params[:filtro]
		if @filtro == nil
			@itens = Atividade.mural(@user).map(&:item)
		else
			@itens = @filtro.constantize.where(:user_id => @user.all_following.map(&:id))
		end
	else
		flash[:notice] = "Você precisa se logar para acessar esta área!"
		redirect_to root_path
	end
  end
end