class Video < ActiveRecord::Base
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
	belongs_to :comment

	has_one :atividade, :as => :item, :dependent => :destroy
	has_one :comment_descricao, :as => :item, :class_name => "Comment", :dependent => :destroy

  has_many :votos, :as => :votavel, :dependent => :destroy

	#validates :player_url, :uniqueness => {:scope => [:user_id, :versiculo_id]}
	validates :user_id, :presence => true
	validates :versiculo_id, :presence => true
	
	default_scope order("created_at DESC")
	scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo)}
		
	after_create :criar_atividade

  def atividades_dependentes
    if comment_descricao != nil
      comment_descricao.atividades_dependentes
    else
      Array.new
    end
  end

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
