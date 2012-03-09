require "acts_as_item"

class Referencia < ActiveRecord::Base
  include ActsAsItem
  acts_as_item

	belongs_to :versiculo_citado, :class_name => "Versiculo"
  has_one :citacao, :foreign_key => "id", :dependent => :destroy
	#validates :ref, :uniqueness => {:scope => [:user_id, :versiculo_id, :comment_id]}
	validates :versiculo_citado_id, :presence => true
	validates :versiculo_id, :presence => {:unless => :comment_id?}

	after_create :criar_atividade, :criar_citacao

	def criar_citacao
    Citacao.create self
  end
	
	def self.criar(referencia_hash)
		referencia = build_referencia(referencia_hash[:ref])
    if referencia == nil
      referencia = Referencia.new
      referencia.errors.add(referencia_hash[:ref], '"' + referencia_hash[:ref] + '" não é uma referência válida')
    else
      referencia.versiculo = referencia_hash[:versiculo]
      referencia.user = referencia_hash[:user]
      referencia.save
    end
		return referencia
	end
	
	def self.criar_com_comment(referencia_hash, texto)
		referencia = criar(referencia_hash)

    if referencia.errors.empty?
      comment = Comment.criar({:user => referencia_hash[:user], :versiculo => referencia_hash[:versiculo], :texto => texto, :item => referencia})
      referencia.errors += comment.errors if comment.errors.any?
    end
		return referencia
	end
	
	def self.build_referencia(ref)
    return nil if !pode_ser? ref
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
	
	def self.pode_ser?(string)
		return string =~ regex
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
