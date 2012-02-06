class Video < ActiveRecord::Base
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
	belongs_to :comment

	has_one :atividade, :as => :item, :dependent => :destroy

	#validates :player_url, :uniqueness => {:scope => [:user_id, :versiculo_id]}
	
	default_scope order("created_at DESC")
	scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo)}
		
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
