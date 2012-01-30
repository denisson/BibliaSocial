class Video < ActiveRecord::Base
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
	belongs_to :comment

	has_one :atividade, :as => :item, :dependent => :destroy
	has_one :comment_item, :as => :item

	validates :player_url, :uniqueness => {:scope => [:user_id, :versiculo_id]}
	
	after_create :criar_atividade
	
	def criar_atividade
		if self.comment == nil
			self.versiculo.atividades.create({:user => self.user, :item => self})
		end
	end
	
	def descricao_atividade
		"adicionou um vídeo"
	end
	
	def descricao_atividade_conectivo
		"em"
	end
end
