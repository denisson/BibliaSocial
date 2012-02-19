class AtividadesController < ApplicationController
  respond_to :js, :html
  def index
    @comment = Comment.new
    lista
  end

  def lista
    @versiculo = Versiculo.find(params[:versiculo_id])
    @filtro =  params[:filtro]
    if @filtro == nil
      @itens = @versiculo.atividades.map(&:item)
      @filtro = "Atividade"
    else
      @itens = @filtro.constantize.where_versiculo(@versiculo)
    end

    respond_with(@itens)
  end
end


