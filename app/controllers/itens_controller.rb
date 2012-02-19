class ItensController < ApplicationController
  respond_to :js, :html, :json
  def destroy
    @versiculo = Versiculo.find(params[:versiculo_id])
    @item = model.find(params[:id])

    if @item and @item.user == current_user
      @item.destroy
    end
    respond_with(@item, :layout => !request.xhr?)
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

    @item.votos.create({:user => current_user, :pontuacao => pontuacao})
  end
end
