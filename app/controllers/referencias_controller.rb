class ReferenciasController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@referencias = @versiculo.referencias
    respond_to do |format|
      format.html
      format.js
    end
  end
end


