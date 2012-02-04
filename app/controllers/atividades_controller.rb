class AtividadesController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@filtro =  params[:filtro]
	if @filtro == nil
		@item = Comment.new
		@itens = @versiculo.atividades.map(&:item)
		@filtro = "Atividade"
	else
		@item = @filtro.constantize.new
		@itens = @filtro.constantize.where(:versiculo_id => @versiculo)
	end
    respond_to do |format|
      format.html
      format.js
    end
  end
end


