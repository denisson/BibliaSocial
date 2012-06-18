class VotosController < ApplicationController
  respond_to :js, :html
  def destroy
    @voto = Voto.find(params[:id])
    @item = @voto.votavel
    @voto.destroy
    @item.reload
    respond_with(@voto, :layout => false)
  end
end
