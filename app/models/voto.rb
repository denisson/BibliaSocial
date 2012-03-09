class Voto < ActiveRecord::Base
  belongs_to :user
  belongs_to :votavel, :polymorphic => true

  validates :user_id, :presence => true, :uniqueness => {:scope => [:votavel_id, :votavel_type]}

  after_create :incrementar_count
  before_destroy :decrementar_count

  def incrementar_count
    votavel.increment!(:likes_count, 1) if like?
    votavel.increment!(:dislikes_count,1) if dislike?
  end

  def decrementar_count
    votavel.decrement!(:likes_count, 1) if like?
    votavel.decrement!(:dislikes_count, 1) if dislike?
  end

  def like?
    pontuacao == 1
  end

  def dislike?
    pontuacao == -1
  end
end
