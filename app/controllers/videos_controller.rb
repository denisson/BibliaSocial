class VideosController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@videos = @versiculo.videos
	@versiculo.comments.build
	@video = Video.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
	@versiculo = Versiculo.find(params[:versiculo_id])
	comment = params[:video][:comment]
	if comment[:texto] != ""
		link_ou_video = Link.criar_com_comment({:user => current_user, :versiculo => @versiculo, :url => params[:video][:link_url]}, comment[:texto])
		if link_ou_video == nil
			flash[:alert] = "Não foi possível criar o link"
		end
	else
		link_ou_video = Link.criar({:user => current_user, :versiculo => @versiculo, :url => params[:video][:link_url]})
	end
	
	redirect_to versiculo_atividades_path(@versiculo) + "?filtro=Video"
  end
end


