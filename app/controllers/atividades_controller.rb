class AtividadesController < ApplicationController
  respond_to :js, :html
  def index
    @comment = Comment.new
    lista
  end

  def lista
    @versiculo = Versiculo.find(params[:versiculo_id])

    @itens = Array.new
    @itens = Atividade.default_includes.where(:versiculo_id => @versiculo.id).map(&:item) if @versiculo.atividades.size > 0

    respond_with(@itens)
  end
end


