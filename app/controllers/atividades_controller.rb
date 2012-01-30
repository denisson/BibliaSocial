class AtividadesController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@atividades = @versiculo.atividades
	
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
	@versiculo = Versiculo.find(params[:versiculo_id])
	comment = params[:link][:comment]
	if comment[:texto] != ""
		@comment = Comment.create_comment_link(current_user, @versiculo, comment[:texto], params[:link][:url])
		if @comment.errors.any?
			flash[:alert] = @comment.errors.inspect
		end
	else
		link_ou_video = Link.create_link current_user, @versiculo, params[:link][:url]
	end
	
	redirect_to versiculo_links_path(@versiculo)
  end
end


