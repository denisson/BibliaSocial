class Capitulo < ActiveRecord::Base
  belongs_to :biblia, :counter_cache => true
  belongs_to :secao, :counter_cache => true
  belongs_to :livro, :counter_cache => true
  
  has_many :versiculos, :dependent => :destroy
  has_many :comentarios, :dependent => :destroy
  
  validates :numero, :presence => true, :numericality => true
  validates :biblia, :presence => true
  validates :secao, :presence => true
  validates :livro, :presence => true
  
  def anterior
    if self.numero == 1
      anterior = livro.capitulos.where(['numero < ?', self.numero]).order('numero DESC').first
      @anterior ||= anterior || (livro.anterior ? livro.anterior.capitulos.order('numero DESC').first : nil)
    else
      anterior = self.clone
      anterior.numero -= 1
      return anterior
    end

  end
  
  def proximo
    if self.numero == self.livro.capitulos_count
      proximo = livro.capitulos.where(['numero > ?', self.numero]).order('numero ASC').first
      @proximo ||= proximo || (livro.proximo ? livro.proximo.capitulos.order('numero ASC').first : nil)
    else
      anterior = self.clone
      anterior.numero += 1
      return anterior
    end
  end
end
