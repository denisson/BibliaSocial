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
      @itens = Atividade.where(:user_id => @user.id).map(&:item)
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
        @itens = @filtro.constantize.where(:user_id => @user.all_following.map(&:id) << @user.id)
      end
      @comment = Comment.new
      render :layout => "application"
    else
      flash[:notice] = "Você precisa se logar para acessar esta área!"
      redirect_to root_path
    end
  end

  def seguir
    @user = User.find(params[:id])
    if (@user != current_user)
      current_user.follow(@user)
    else
      flash[:notice] = "Não é possível seguir a si mesmo!"
    end

    render :partial => 'partials/botao_seguir', :locals => {:user => @user}
  end

  def deixar
     @user = User.find(params[:id])
    if (@user != current_user)
      current_user.stop_following(@user)
    else
      flash[:notice] = "Não é possível seguir a si mesmo!"
    end
    render :partial => 'partials/botao_seguir', :locals => {:user => @user}
  end

  def seguidores
    @user = User.find(params[:id])
    @users = @user.followers
    @tituloDivisor = "Seguidores"
    render :action => "lista"
  end

  def seguindo
    @user = User.find(params[:id])
    @users = @user.all_following
    @tituloDivisor = "Seguindo"
    render :action => "lista"
  end
end