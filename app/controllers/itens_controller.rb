class ItensController < ApplicationController
  respond_to :html, :js
  def destroy

    @item = model.find(params[:id])

    #Tem que ser do usuário logado e o item não pode ser dependente de um comentário
    if @item and @item.pode_excluir?(current_user)
      @item.destroy
    end
    #@versiculo.reload
    @versiculo = Versiculo.find(params[:versiculo_id]) if params[:versiculo_id] != nil
    #respond_with(@item, :layout => !request.xhr?)
    render 'atividades/destroy', :layout => !request.xhr?
  end

  def likes
    @item = model.find(params[:id])
    @users = @item.likes.map(&:user)
    @tituloDivisor = "Pessoas que gostaram"
    render 'users/lista', :layout => false
  end

  def dislikes
    @item = model.find(params[:id])
    @users = @item.dislikes.map(&:user)
    @tituloDivisor = "Pessoas que nao gostaram"
    render 'users/lista', :layout => false
  end

  def like
    votar(1)
  end

  def dislike
    votar(-1)
  end

  private
  def votar(pontuacao)
    @item = model.find(params[:id])

    @voto = @item.votos.create({:user => current_user, :pontuacao => pontuacao})
    @item.reload
    respond_with(@voto, :layout => false) do |format|
      format.html {render 'votos/votar', :layout => false}
    end
  end
end
