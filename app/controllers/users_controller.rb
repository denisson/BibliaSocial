class UsersController < ApplicationController

  def edit
    @user = current_user
    @user_edit = current_user
    sidebar
  end

  def update
    @user = current_user
    @user_edit = User.find(params[:id])
    return if current_user != @user_edit

    @user_edit.nome = params[:user][:nome]
    @user_edit.foto = params[:user][:foto] || @user.foto
    @user_edit.save

    respond_to do |format|
      if @user_edit.errors.empty?
        format.html  { redirect_to(@user_edit, :notice => 'Usuário atualizado com sucesso.') }
        format.json  { head :no_content }
      else
        sidebar
        format.html  { render :action => "edit" }
        format.json  { render :json => @user_edit.errors,
              :status => :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @filtro =  params[:filtro]
    if @filtro == nil
      @itens = Atividade.publicacoes.where(:user_id => @user.id).recentes.map(&:item)
    else
      @itens = @filtro.constantize.publicacoes.recentes.where(:user_id => @user)
    end
    sidebar
  end

  def destroy
    precisa_de_login
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url
  end

  def mural
    return if precisa_de_login
    @user = current_user
    @filtro =  params[:filtro]
    if @filtro == nil
      @itens = Atividade.mural(@user).map(&:item)
    else
      @itens = @filtro.constantize.where(:user_id => @user.all_following.map(&:id) << @user.id)
    end
    @comment = Comment.new
    render :layout => "application"
  end

  def seguir
    return if precisa_de_login
    @user = User.find(params[:id])
    current_user.seguir(@user)
    render :partial => 'partials/botao_seguir', :locals => {:user => @user}
  end

  def deixar
    return if precisa_de_login
    @user = User.find(params[:id])
    current_user.deixar_de_seguir(@user)
    render :partial => 'partials/botao_seguir', :locals => {:user => @user}
  end

  def seguidores
    @user = User.find(params[:id])
    @users_paginate = @user.followings.includes(:follower).paginate(:page => params[:page], :per_page => 15)
    @users = @users_paginate.map(&:follower)
    @tituloDivisor = "Seguidores"
    sidebar
    render :action => "lista"
  end

  def seguindo
    @user = User.find(params[:id])
    @users_paginate = @user.follows.includes(:followable).paginate(:page => params[:page], :per_page => 15)
    @users = @users_paginate.map(&:followable)
    @tituloDivisor = "Seguindo"
    sidebar
    render :action => "lista"
  end

  def top
    #@versiculos = Versiculo.limit(12).paginate(:page => params[:page], :per_page => 3)
    @tituloDivisor = "Top Usuários <span class='info'>#{I18n.t('bibliasocial.top.usuarios')}</span>"
    @users_paginate = User.top.paginate(:page => params[:page], :per_page => 15)
    @users = @users_paginate
    render :action => "lista", :layout => "content"
  end

  protected
  def sidebar
    @seguindo = @user.follows.limit(10).map(&:followable)
    @seguidores = @user.followings.limit(10).map(&:follower)
    @top_publicacoes = @user.atividades.top.limit(3).map(&:item)
  end
end