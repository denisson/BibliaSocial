class Atividade < ActiveRecord::Base
	belongs_to :item, :polymorphic => true
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
	
	default_scope order("created_at DESC")
	scope :mural, lambda { |user| where(:user_id => user.all_following.map(&:id))}
end
