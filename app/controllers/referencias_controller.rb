class ReferenciasController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@referencias = @versiculo.referencias
	@versiculo.comments.build
	@referencia = Referencia.new
	
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
	@versiculo = Versiculo.find(params[:versiculo_id])
	comment = params[:referencia][:comment]
	if comment[:texto] != ""
		@comment = Comment.create_comment_referencia(current_user, @versiculo, comment[:texto], params[:referencia][:ref])
		if @comment.errors.any?
			flash[:alert] = @comment.errors.inspect
		end
	else
		referencia = Referencia.create_referencia current_user, @versiculo, params[:referencia][:ref]
	end
	
	redirect_to versiculo_referencias_path(@versiculo)
  end
end


