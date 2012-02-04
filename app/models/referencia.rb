class Referencia < ActiveRecord::Base
	belongs_to :user
	belongs_to :comment
	belongs_to :versiculo, :counter_cache => true
	belongs_to :versiculo_citado, :class_name => "Versiculo"
	
	has_one :atividade, :as => :item, :dependent => :destroy
	has_one :comment_item, :as => :item
	
	validates :ref, :uniqueness => {:scope => [:user_id, :versiculo_id]}
	
	default_scope order("created_at DESC")
	
	after_create :criar_atividade
	
	def criar_atividade
		if self.comment == nil
			self.versiculo.atividades.create({:user => self.user, :item => self})
		end
	end
	
	def self.build_referencia(ref)
		referencia = nil
		
		livros_nomes = LIVROS.keys
		livros_e_abreviaturas = LIVROS.merge(LIVROS_ABREVIADOS)
		
		if ref =~ regex
			livro = $2
			capitulo_versiculo = $7
			url_fim = ''
			cap = ''
			ver = ''
			if capitulo_versiculo =~ /(\d{1,3})[ ]?(\:|\.)[ ]?(\d{1,3})/
				cap = $1
				ver = $3
				url_fim = '/' + cap + '/' + ver
			elsif capitulo_versiculo =~ /(\d{1,3})/
				cap = $1
				url_fim = '/' + cap
			end

			nome_deste_livro = livros_e_abreviaturas[livro.mb_chars.downcase.to_s]
			if nome_deste_livro != nil #é realmente uma referência
				ver = 1 if ver == ''
				livro = Livro.where(:permalink => nome_deste_livro).first
				capitulo = livro.capitulos.where(:numero => cap).first
				if capitulo != nil
					versiculo = capitulo.versiculos.where(:numero => ver).first
				else
					versiculo = nil
				end
				
				if versiculo != nil
					referencia = new({:versiculo_citado => versiculo, :ref => ref})
				end
			end
		end
		return referencia
	end
	
	def self.create_referencia(user, versiculo, ref)
		referencia = build_referencia(ref)
		return nil if referencia == nil
		referencia.versiculo = versiculo
		referencia.user = user
		referencia.save
		return referencia
	end

	def self.create_referencia_comment(comment, ref)
		referencia = build_referencia(ref)
		return nil if referencia == nil
		referencia.versiculo = comment.versiculo
		referencia.user = comment.user
		referencia.comment = comment
		referencia.save
		return referencia
	end
	
	def self.regex
		return Regexp.new('(((([1-3]|[iI]{1,3})( )?)?([a-zá-úà-ùâ-ûä-üçA-ZÁ-ÚÀ-ÙÂ-ÛÄ-ÜÇ]+))[ ]((\d{1,3})((:|-|,|\.)( )?(\d{1,3}))*))')
	end
	
	def pretty_ref
		if ref =~ Referencia.regex
			capitulo_versiculo = $7			
			return versiculo_citado.livro.nome + " " + capitulo_versiculo.strip.gsub(":", ".")
		else
			return ref
		end
	end
	
	def descricao_atividade
		"adicionou uma referência"
	end
	
	def descricao_atividade_conectivo
		"em"
	end
end
