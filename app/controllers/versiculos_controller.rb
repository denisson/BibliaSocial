class VersiculosController < ApplicationController

  def top
    if params[:capitulo_id].nil?
      @versiculos = Versiculo.top.paginate(:page => params[:page], :per_page => 10)
    else
      @versiculos = Versiculo.where(:capitulo_id => params[:capitulo_id]).top.paginate(:page => params[:page], :per_page => 10)
    end
  end

end