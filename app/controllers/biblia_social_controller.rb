class BibliaSocialController < ApplicationController
  #caches_page :livro, :capitulo, :versiculo
    
  #before_filter :find_biblia
  
  def index
    consulta_ultimas_publicacoes
    top

    respond_to do |format|
      format.html
    end
  end

  def ultimas_publicacoes
    consulta_ultimas_publicacoes

    respond_to do |format|
      format.js
    end
  end

  def consulta_ultimas_publicacoes
    params[:page] = 1 if params[:page].nil?
    @versiculos = Versiculo.where('atividades.item_type != "Citacao"').joins(:atividades).group('versiculo_id').order('max(atividades.created_at) DESC').paginate(:page => params[:page], :per_page => 3)
    @next_page = @versiculos.current_page + 1
  end
  
  def livro
    params[:capitulo] = 1
    capitulo
    render "capitulo"
  end
  
  def capitulo
    @livro = Livro.where(:permalink => params[:livro]).first
    @capitulo = @livro.capitulos.where(:numero => params[:capitulo]).first
    @versiculos = @capitulo.versiculos.order('numero ASC')

    top_do_capitulo
  end
  
  def versiculo
    capitulo
    @versiculo = @capitulo.versiculos.where(:numero => params[:versiculo]).first
    render "capitulo"
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
  filtro = {:livro_id => params[:livro_id]}  unless params[:livro_id].nil?
  filtro = {:secao_id => params[:secao_id]}  unless params[:secao_id].nil?
  @versiculos = Versiculo.default_includes.search(params[:keywords], :rank_mode => :proximity , :match_mode => :extended, :max_matches => 30_000, :page => params[:page], :per_page => 15, :with => filtro)
  @filtro_livros = Versiculo.search(params[:keywords], :rank_mode => :proximity , :match_mode => :extended, :max_matches => 30_000, :group_by => 'livro_id', :group_function => :attr, :group_clause   => "livro_id asc", :per_page => 66 )
	@filtro_testamentos = Versiculo.search(params[:keywords], :rank_mode => :proximity , :match_mode => :extended, :max_matches => 30_000, :group_by => 'secao_id', :group_function => :attr, :group_clause   => "secao_id asc" )

  end
  
  protected
  
  #def find_biblia

    #@biblia = Biblia.find(1)
    #@velho_testamento = @biblia.secoes.where(:permalink => 'velho-testamento').first
    #@novo_testamento = @biblia.secoes.where(:permalink => 'novo-testamento').first
    #@livros_velho_testamento = @velho_testamento.livros.order('numero ASC')
    #@livros_novo_testamento = @novo_testamento.livros.order('numero ASC')
  #end

  def top
    @top_users = User.top.limit(10)
    @top_versiculos = Versiculo.top.limit(5)

    @top_itens = Array.new
    @top_comment = Comment.top.limit(1).first
    @top_video = Video.top.limit(1).first
    @top_link = Link.top.limit(1).first
    @top_itens << @top_video if !@top_video.nil?
    @top_itens << @top_link if !@top_link.nil?
    @top_itens << @top_comment if !@top_comment.nil?
  end

  def top_do_capitulo
    @top_users = Array.new
    @top_versiculos = @capitulo.versiculos.top.limit(5)

    @top_itens = Array.new
    @top_comment = Comment.top_do_capitulo(@capitulo.id).limit(1).first
    @top_video = Video.top_do_capitulo(@capitulo.id).limit(1).first
    @top_link = Link.top_do_capitulo(@capitulo.id).limit(1).first
    @top_itens << @top_video if !@top_video.nil?
    @top_itens << @top_link if !@top_link.nil?
    @top_itens << @top_comment if !@top_comment.nil?
  end
end