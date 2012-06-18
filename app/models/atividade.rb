class Atividade < ActiveRecord::Base
	belongs_to :item, :polymorphic => true
	belongs_to :user, :counter_cache => true
	belongs_to :versiculo, :counter_cache => true
	#validates :user_id, :presence => true
  validates :item_id, :presence => true
  validates :item_type, :presence => true

  scope :recentes, order("created_at DESC")
  scope :publicacoes, where(:item_type => ['Comment', 'Link', 'Video'])
	scope :mural, lambda { |user| recentes.publicacoes.where(:user_id => user.all_following.map(&:id) << user.id)}
  scope :top, publicacoes.order("saldo_votos DESC").recentes
  scope :top_do_capitulo,  lambda { |capitulo_id| joins(:versiculo).where("versiculos.capitulo_id" => capitulo_id).top}
  scope :default_includes, includes(:item)


  after_create :atualizar_reputacao_user
  after_destroy :atualizar_reputacao_user

  def atualizar_saldo_votos
    self.update_attributes!(:saldo_votos => "(likes_count - dislikes_count)")
  end

  def atualizar_reputacao_user
    self.user.atualizar_reputacao
  end
end
