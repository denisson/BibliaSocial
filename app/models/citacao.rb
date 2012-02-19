class Citacao < ActiveRecord::Base
	set_table_name 'referencias'

	belongs_to :user
	belongs_to :comment
	belongs_to :versiculo, :foreign_key => "versiculo_citado_id"
	belongs_to :versiculo_origem, :foreign_key => "versiculo_id", :class_name => "Versiculo"

	has_one :atividade, :as => :item, :dependent => :destroy
	
	default_scope order("created_at DESC")
	scope :where_versiculo , lambda { |versiculo| where(:versiculo_citado_id => versiculo)}
	validates :user_id, :presence => true

  def atividades_dependentes
      Array.new
  end

	def self.criar_atividade(referencia)
		citacao = Citacao.find(referencia.id)
		referencia.versiculo_citado.atividades.create({:item => citacao, :user => referencia.user})
	end
	
	def pretty_ref
		versiculo_origem.ref
	end
	
	def descricao_atividade
		"citou este versiculo em"
	end
	
	def descricao_atividade_conectivo
		""
	end
end
