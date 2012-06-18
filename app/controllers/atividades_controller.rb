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

  def top
    if params[:capitulo_id].nil?
      @atividades = Atividade.default_includes.top.paginate(:page => params[:page], :per_page => 10)
    else
      @atividades = Atividade.default_includes.top_do_capitulo(params[:capitulo_id]).paginate(:page => params[:page], :per_page => 10)
    end
  end
end


