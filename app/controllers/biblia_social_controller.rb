class BibliaSocialController < ApplicationController
  caches_page :livro, :capitulo, :versiculo
    
  before_filter :find_biblia
  
  def index
    @versiculos = Versiculo.joins(:comentarios).group('versiculo_id').order('max(comentarios.created_at) DESC').paginate(:page => params[:page], :per_page => 3)
	
	#@versiculos.first.comments.create(:texto => "Este é o primeiro comentário", :user => current_user)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def livro
    @livro = @biblia.livros.where(:permalink => params[:livro]).first
  end
  
  def capitulo
    @livro = @biblia.livros.where(:permalink => params[:livro]).first
    @capitulo = @livro.capitulos.where(:numero => params[:capitulo]).first
    @versiculos = @capitulo.versiculos.order('numero ASC')
  end
  
  def versiculo
    @livro = @biblia.livros.where(:permalink => params[:livro]).first
    @capitulo = @livro.capitulos.where(:numero => params[:capitulo]).first
    @versiculo = @capitulo.versiculos.where(:numero => params[:versiculo]).first
  end
    
  def search
    if params[:keywords] =~ /((^\d\s[^\s\d]+)|([^\s\d]+))\s([\d]+)(:([\d]+))?/i
      livro = Livro.where(:nome => $1).first
      capitulo = livro.capitulos.where(:numero => $4).first if livro
      versiculo = capitulo.versiculos.where(:numero => $6).first if capitulo
      
      if versiculo
        redirect_to "/#{livro.permalink}/#{capitulo.numero}/#{versiculo.numero}?keywords=#{CGI::escape(params[:keywords])}"
      elsif capitulo
        redirect_to "/#{livro.permalink}/#{capitulo.numero}?keywords=#{CGI::escape(params[:keywords])}"
      elsif livro
        redirect_to "/#{livro.permalink}?keywords=#{CGI::escape(params[:keywords])}"
      end
    end
	#@versiculos = Versiculo.buscar(params[:keywords]).paginate(:page => params[:page], :per_page => 10)
	@versiculos = Versiculo.search(params[:keywords], :rank_mode => :proximity , :match_mode => :extended, :page => params[:page], :per_page => 10)
  end
  
  protected
  
  def find_biblia
    @biblia = Biblia.find(1)
    @velho_testamento = @biblia.secoes.where(:permalink => 'velho-testamento').first
    @novo_testamento = @biblia.secoes.where(:permalink => 'novo-testamento').first
    @livros_velho_testamento = @velho_testamento.livros.order('numero ASC')
    @livros_novo_testamento = @novo_testamento.livros.order('numero ASC')
  end
end