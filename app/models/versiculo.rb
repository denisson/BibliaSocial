class Versiculo < ActiveRecord::Base
  belongs_to :biblia, :counter_cache => true
  belongs_to :secao, :counter_cache => true
  belongs_to :livro, :counter_cache => true
  belongs_to :capitulo, :counter_cache => true
  
  has_many :comentarios, :dependent => :destroy
  
  validates :numero, :presence => true, :numericality => true
  validates :texto, :presence => true
  validates :biblia, :presence => true
  validates :secao, :presence => true
  validates :livro, :presence => true
  validates :capitulo, :presence => true
  
  scope :default_includes, includes(:capitulo, :livro)
  
  def self.search(keywords)
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
end
