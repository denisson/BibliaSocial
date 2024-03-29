class Versiculo < ActiveRecord::Base
  belongs_to :biblia, :counter_cache => true
  belongs_to :secao, :counter_cache => true
  belongs_to :livro, :counter_cache => true
  belongs_to :capitulo, :counter_cache => true
  
  has_many :comentarios, :dependent => :destroy
  has_many :comments, :conditions => { :item_id => nil}
  has_many :referencias
  has_many :citacoes, :foreign_key => "versiculo_citado_id"
  has_many :links
  has_many :videos
  has_many :atividades, :order => "created_at DESC"
  
  validates :numero, :presence => true, :numericality => true
  validates :texto, :presence => true
  validates :biblia, :presence => true
  validates :secao, :presence => true
  validates :livro, :presence => true
  validates :capitulo, :presence => true
  
  scope :default_includes, joins(:capitulo, :livro)
  scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo)}
  scope :top, where("atividades_count > 0").order("atividades_count DESC")
	
  define_index do
    # fields
    indexes texto
    has livro_id, secao_id
    has livro.nome, :as => :livro_nome
    has secao.nome, :as => :secao_nome
  end
  
  def self.buscar(keywords)
    Versiculo.default_includes.where(['MATCH (texto) AGAINST (?)', keywords])
#	select match(texto) against('"venha a mim"' in boolean mode) * 10 + match(texto) against('venha a mim')  peso,versiculos.*  from versiculos where match(texto) against("venha a mim") order by peso desc
  end
  
  def anterior
    anterior = capitulo.versiculos.where(['numero < ?', self.numero]).order('numero DESC').first
    @anterior ||= anterior || (capitulo.anterior ? capitulo.anterior.versiculos.order('numero DESC').first : nil)
  end
  
  def proximo
    proximo = capitulo.versiculos.where(['numero > ?', self.numero]).order('numero ASC').first
    @proximo ||= proximo || (capitulo.proximo ? capitulo.proximo.versiculos.order('numero ASC').first : nil)
  end
  
  def url
	livro = self.capitulo.livro.permalink
	capitulo = self.capitulo.numero.to_s
	versiculo = self.numero.to_s
	return "/" + livro + "/" + capitulo + "/" + versiculo
  end
  
  def ref
	livro = self.capitulo.livro.nome
	capitulo = self.capitulo.numero.to_s
	versiculo = self.numero.to_s
	return livro + " " + capitulo + "." + versiculo
  end
end

