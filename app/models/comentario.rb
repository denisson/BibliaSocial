class Comentario < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Comentario', :foreign_key => 'parent_comment_id'
  belongs_to :livro, :counter_cache => true
  belongs_to :capitulo, :counter_cache => true
  belongs_to :versiculo, :counter_cache => true
  
  validates :href, :presence => true
  validates :comment_id, :presence => true
  
  scope :default_includes, includes(:versiculo => [:capitulo, :livro])
end
