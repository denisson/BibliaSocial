class CitacoesController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@citacoes = @versiculo.citacoes
	
    respond_to do |format|
      format.html
      format.js
    end
  end
 
end


