class Livro < ActiveRecord::Base
  belongs_to :biblia, :counter_cache => true
  belongs_to :secao, :counter_cache => true
  
  has_many :capitulos, :dependent => :destroy
  has_many :versiculos, :dependent => :destroy
  has_many :comentarios, :dependent => :destroy
  
  validates :nome, :presence => true
  validates :permalink, :presence => true
  validates :numero, :presence => true, :numericality => true
  validates :biblia, :presence => true
  validates :secao, :presence => true
  
  def anterior
    @anterior ||= biblia.livros.where(['numero < ?', self.numero]).order('numero DESC').first
  end
  
  def proximo
    @proximo ||= biblia.livros.where(['numero > ?', self.numero]).order('numero ASC').first
  end
end
