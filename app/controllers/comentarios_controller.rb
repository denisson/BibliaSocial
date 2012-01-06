require "twitter"

class ComentariosController < ApplicationController
  
  def create
    if params[:comentario][:href] =~ /bibliasocial\.com\/([\d\-\w]+)\/(\d+)\/(\d+)/i
      livro = Livro.where(:permalink => $1).first
      capitulo = livro.capitulos.where(:numero => $2).first
      @versiculo = capitulo.versiculos.where(:numero => $3).first
      @versiculo.comentarios.create(params[:comentario])
	  divulgar
    end
    render :nothing => true
  end
  
  def destroy
    @comentario = Comentario.where(:comment_id => params[:id]).first
    @comentario.destroy if @comentario
    render :nothing => true
  end
  
  protected
  
  class Helper
	  include Singleton
	  include ActionView::Helpers::TextHelper
  end
  
  def help
    Helper.instance
  end
  
  def divulgar
	Twitter.configure do |config|
	  config.consumer_key = "YWcEZzsljnyvM6xsKfkTmw"
	  config.consumer_secret = "QLVVUM9hgYQYxm9DudgjLhPbMhv9u47wxcbIvK2LZsM"
	  config.oauth_token = 	"330271534-So5ityxmGY8stA6tYpEMaydQvfycuXy4DvMSGLwy"
	  config.oauth_token_secret = "O3b72OatPrd7KZLbLJP9WQuFlfPYVjMXpK0cMaz3e4"
	end
	client = Twitter::Client.new
	href = params[:comentario][:href]
	tamanho_url = href.length
	texto_twettar =  '"' << help.truncate(@versiculo.texto, :length => 140 - 2 - 20) << '" ' << href
	client.update(texto_twettar)
  end
end
