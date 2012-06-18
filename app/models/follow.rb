class Follow < ActiveRecord::Base

  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true

  after_create :incrementar_count
  before_destroy :decrementar_count

  def incrementar_count
    User.increment_counter(:seguidores_count, followable.id)
    User.increment_counter(:seguindo_count, follower.id)
  end

  def decrementar_count
    User.decrement_counter(:seguidores_count, followable.id)
    User.decrement_counter(:seguindo_count, follower.id)
  end

  def block!
    self.update_attribute(:blocked, true)
  end

end
