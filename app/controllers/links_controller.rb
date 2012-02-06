class LinksController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@links = @versiculo.links
	@versiculo.comments.build
	@link = Link.new

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
	@versiculo = Versiculo.find(params[:versiculo_id])
	comment = params[:link][:comment]
	if comment[:texto] != ""
		link_ou_video = Link.criar_com_comment({:user => current_user, :versiculo => @versiculo, :url => params[:link][:url]}, comment[:texto])
		if link_ou_video == nil
			flash[:alert] = "Não foi possível criar o link"
		end
	else
		link_ou_video = Link.criar({:user => current_user, :versiculo => @versiculo, :url => params[:link][:url]})
	end
	
	redirect_to versiculo_atividades_path(@versiculo) + "?filtro=Link"
  end
end


