class VideosController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@videos = @versiculo.videos
    respond_to do |format|
      format.html
      format.js
    end
  end
end


