class LinksController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@links = @versiculo.links
    respond_to do |format|
      format.html
      format.js
    end
  end
end


