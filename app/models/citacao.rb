class Citacao < ActiveRecord::Base
	set_table_name 'referencias'

	belongs_to :user
	belongs_to :comment
	belongs_to :versiculo, :foreign_key => "versiculo_citado_id", :counter_cache => true
	belongs_to :versiculo_origem, :foreign_key => "versiculo_id", :class_name => "Versiculo"
	
	scope :where_versiculo , lambda { |versiculo| where(:versiculo_citado_id => versiculo)}
	
	def self.criar_atividade(referencia)
		citacao = Citacao.find(referencia.id)
		referencia.versiculo_citado.atividades.create({:item => citacao})
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
