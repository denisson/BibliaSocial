class ReferenciasController < ItensController

  def model
    Referencia
  end

  #def index
  #@versiculo = Versiculo.find(params[:versiculo_id])
  #@referencias = @versiculo.referencias
  #@versiculo.comments.build
  #@referencia = Referencia.new
  #
  #  respond_to do |format|
  #    format.html
  #    format.js
  #  end
  #end
  #
  #def create
  #@versiculo = Versiculo.find(params[:versiculo_id])
  #comment = params[:referencia][:comment]
  #if comment[:texto] != ""
		#@referencia = Referencia.criar_com_comment({:user => current_user, :versiculo => @versiculo, :ref => params[:referencia][:ref]}, comment[:texto])
		#if @referencia == nil
		#	flash[:alert] = "Não foi possível criar a ref"
		#end
  #else
		#@referencia = Referencia.criar({:user => current_user, :versiculo => @versiculo, :ref => params[:referencia][:ref]})
  #end
  #
  #redirect_to versiculo_atividades_path(@versiculo) + "?filtro=Referencia"
  #end
end


