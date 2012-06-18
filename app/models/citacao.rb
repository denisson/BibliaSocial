class Citacao < ActiveRecord::Base
	set_table_name 'referencias'


  belongs_to :user
  belongs_to :comment
  has_one :referencia, :foreign_key => "id"
	belongs_to :versiculo, :foreign_key => "versiculo_citado_id"
	belongs_to :versiculo_origem, :foreign_key => "versiculo_id", :class_name => "Versiculo"

  has_one :atividade, :as => :item

	scope :where_versiculo , lambda { |versiculo| where(:versiculo_citado_id => versiculo)}
  default_scope order("created_at DESC")

  def self.create(referencia)
    citacao = Citacao.find(referencia.id)
    citacao.criar_atividade
    Versiculo.increment_counter(:citacoes_count, citacao.versiculo_citado_id)
  end

  def destroy
    atividade.destroy if !atividade.nil?
    Versiculo.decrement_counter(:citacoes_count, self.versiculo_citado_id)
  end

  def atividades_dependentes
      Array.new
  end

	def criar_atividade
		versiculo.atividades.create({:item => self, :user => self.user})
	end

  def comentario
    if comment != nil
      comment
    else
      referencia.comment_descricao
    end
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

  def votavel
    Referencia.find(self.id)
  end

  def independente?
    false
  end

  def pode_excluir?(usuario_tenta_excluir)
     false
  end
end
