class Comment < ActiveRecord::Base
  belongs_to :versiculo
  belongs_to :user
  belongs_to :item, :polymorphic => true
  
  has_many :referencias#, :dependent => :delete_all
  has_many :links, :dependent => :delete_all
  has_many :videos, :dependent => :delete_all
  has_many :votos, :as => :votavel, :dependent => :destroy

  
  has_one :atividade, :as => :item, :dependent => :destroy
  
  validates :texto, :presence => true, :uniqueness => {:scope => [:user_id, :versiculo_id]}
  validates :texto_html, :presence => true
  validates :user_id, :presence => true
  validates :versiculo_id, :presence => true
  
  #default_scope order("created_at DESC")
  scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo, :item_id => nil)}
  
  after_create :criar_atividade

  def before_destroy
    referencias.each do |referencia|
      referencia.citacao.destroy
    end
    referencias.delete_all
  end

  def atividades_dependentes
     videos + links + referencias
  end

  def criar_atividade
	if self.item == nil
		self.versiculo.atividades.create({:user => self.user, :item => self})
	end
  end
  
  def self.criar(comment)
	texto_html = TextoHtml.new(comment[:texto].sanitize)
	comment[:texto_html] = texto_html.texto
	@comment = comment[:versiculo].comments.create(comment)
	if @comment.errors.empty?
		@comment.criar_referencias texto_html.referencias
		@comment.criar_links texto_html.links
	end
	return @comment
  end
  
  def criar_referencias(referencias)
	referencias.each do |referencia|
		referencia.user = self.user
		referencia.versiculo = self.versiculo
		referencia.comment = self
		referencia.save
	end
  end
  
  def criar_links(links)
	links.each do |link|
		Link.criar({:user => self.user, :versiculo => self.versiculo, :url => link, :comment => self})
	end
  end

  def descricao_atividade
	"comentou"
  end
  
  def descricao_atividade_conectivo
	""
  end
end
