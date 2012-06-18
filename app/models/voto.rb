class Voto < ActiveRecord::Base
  belongs_to :user
  belongs_to :votavel, :polymorphic => true

  validates :user_id, :presence => true, :uniqueness => {:scope => [:votavel_id, :votavel_type]}

  after_create :incrementar_count
  before_destroy :decrementar_count

  def incrementar_count
    votavel.class.increment_counter(:likes_count, votavel.id)  if like?
    votavel.class.increment_counter(:dislikes_count, votavel.id)  if dislike?
    votavel.atualizar_saldo_votos

    User.increment_counter(:likes_count, votavel.user_id)  if like?
    User.increment_counter(:dislikes_count, votavel.user_id)  if dislike?
    votavel.user.atualizar_reputacao

    if !votavel.atividade.nil?
      votavel.atividade.class.increment_counter(:likes_count, votavel.atividade.id)  if like?
      votavel.atividade.class.increment_counter(:dislikes_count, votavel.atividade.id)  if dislike?
      votavel.atividade.atualizar_saldo_votos
    end
  end

  def decrementar_count
    votavel.class.decrement_counter(:likes_count, votavel.id)  if like?
    votavel.class.decrement_counter(:dislikes_count, votavel.id)  if dislike?
    votavel.atualizar_saldo_votos

    User.decrement_counter(:likes_count, votavel.user_id)  if like?
    User.decrement_counter(:dislikes_count, votavel.user_id)  if dislike?
    votavel.user.atualizar_reputacao

    if !votavel.atividade.nil?
      votavel.atividade.class.decrement_counter(:likes_count, votavel.atividade.id)  if like?
      votavel.atividade.class.decrement_counter(:dislikes_count, votavel.atividade.id)  if dislike?
      votavel.atividade.atualizar_saldo_votos
    end
  end

  def like?
    pontuacao == 1
  end

  def dislike?
    pontuacao == -1
  end
end
