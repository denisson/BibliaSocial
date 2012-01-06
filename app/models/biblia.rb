class Biblia < ActiveRecord::Base
  belongs_to :biblia, :counter_cache => true
  
  has_many :secoes, :dependent => :destroy
  has_many :livros, :dependent => :destroy
  has_many :capitulos, :dependent => :destroy
  has_many :versiculos, :dependent => :destroy
  
  validates :nome, :presence => true
  validates :permalink, :presence => true
end
