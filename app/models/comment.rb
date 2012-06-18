require "acts_as_item"

class Comment < ActiveRecord::Base
  include ActsAsItem
  acts_as_item_comment

  belongs_to :item, :polymorphic => true
  
  has_many :referencias, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  
  validates :texto, :presence => true#, :uniqueness => {:scope => [:user_id, :versiculo_id]}
  validates :texto_html, :presence => true

  scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo, :item_id => nil)}


  #def before_destroy
  #  if referencias.size > 0
  #    referencias.each do |referencia|
  #      referencia.citacao.destroy
  #    end
  #    referencias.delete_all
  #  end
  #  links.delete_all if links.size > 0
  #  videos.delete_all if videos.size > 0
  #  Versiculo.reset_counters versiculo.id, :
  #end

  def atividades_dependentes
     retorno = Array.new
     retorno = retorno + videos if videos.size > 0
     retorno = retorno + links if links.size > 0
     retorno = retorno + referencias if referencias.size > 0
     return retorno
  end

  def criar_atividade
    if self.item == nil
      Atividade.create({:user => self.user, :item => self, :versiculo => self.versiculo, :created_at => self.created_at, :updated_at => self.updated_at})
    end
  end
  
  def self.criar(comment)
    texto_html = TextoHtml.new(comment[:texto].sanitize)
    comment[:texto_html] = texto_html.texto
    @comment = Comment.create(comment)
    if @comment.errors.empty?
      @comment.criar_referencias texto_html.referencias
      @comment.criar_links texto_html.links
      @comment.reload
    end
    return @comment
  end
  
  def criar_referencias(referencias)
    referencias.each do |referencia|
      referencia.user = self.user
      referencia.versiculo = self.versiculo
      referencia.comment = self
      referencia.created_at = self.created_at
      referencia.updated_at =  self.updated_at
      referencia.save
    end
  end
  
  def criar_links(links)
    links.each do |link|
      Link.criar({:user => self.user, :versiculo => self.versiculo, :url => link, :comment => self, :created_at => self.created_at, :updated_at => self.updated_at})
    end
  end

  def descricao_atividade
  	"comentou"
  end
  
  def descricao_atividade_conectivo
  	""
  end

  def self.label
    "Comentário"
  end
end
