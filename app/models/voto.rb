class Voto < ActiveRecord::Base
  belongs_to :user
  belongs_to :votavel, :polymorphic => true

  validates :user_id, :presence => true, :uniqueness => {:scope => [:votavel_id, :votavel_type]}
end
