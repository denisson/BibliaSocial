class Comment < ActiveRecord::Base
  belongs_to :versiculo, :counter_cache => true
  belongs_to :user
  belongs_to :item, :polymorphic => true
  
  has_many :referencias, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  
  has_one :atividade, :as => :item, :dependent => :destroy
  
  validates :texto, :presence => true, :uniqueness => {:scope => [:user_id, :versiculo_id]}
  validates :texto_html, :presence => true
  validates :user_id, :presence => true
  
  default_scope order("created_at DESC")
  
  after_create :criar_atividade
  
  def criar_atividade
	self.versiculo.atividades.create({:user => self.user, :item => self})
  end
  
  def self.create_comment(user, versiculo, texto)
	texto_html = TextoHtml.new(texto.sanitize)
	comment = {
		:user => user,
		:texto => texto,
		:texto_html => texto_html.texto
	}
	@comment = versiculo.comments.create(comment)
	if @comment.errors.empty?
		@comment.create_referencias texto_html.referencias
		@comment.create_links texto_html.links
	end
	return @comment
  end
  
  def create_referencias(referencias)
	referencias.each do |referencia|
		referencia.user = self.user
		referencia.versiculo = self.versiculo
		referencia.comment = self
		referencia.save
	end
  end
  
  def create_links(links)
	links.each do |link|
		Link.create_link_comment self, link
	end
  end
  
  def self.create_comment_link(user, versiculo, texto, url)
	@comment = create_comment(user, versiculo, texto)
	if @comment.errors.empty?
		@comment.item = Link.create_link_comment @comment, url
		@comment.save
	end
	return @comment
  end
  
  def self.create_comment_referencia(user, versiculo, texto, ref)
	@comment = create_comment(user, versiculo, texto)
	if @comment.errors.empty?		
		@comment.item = Referencia.create_referencia_comment @comment, ref
		@comment.save
	end
	return @comment
  end

  def descricao_atividade
	"comentou"
  end
  
  def descricao_atividade_conectivo
	""
  end
end
