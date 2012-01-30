class Atividade < ActiveRecord::Base
	belongs_to :item, :polymorphic => true
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
end
