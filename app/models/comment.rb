class Comment < ActiveRecord::Base
  @@referencias = Array.new
  @@links = Array.new
  belongs_to :versiculo#, :counter_cache => true
  belongs_to :user#, :counter_cache => true
  
  has_many :referencias, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  
  validates :texto, :presence => true
  validates :user_id, :presence => true
  
  def self.formatar_links(comentario)
	@@links = Array.new
	comentario_formatado = comentario.dup
	comentario_formatado.gsub!(URI.regexp) do |match|
		@@links << match
		'<a href="'+match+'" target="_blank">'+match+'</a>'
	end
	return comentario_formatado
  end
  
  def self.formatar_html(comentario)
	@@referencias = Array.new
  
	livros_nomes = LIVROS.keys
	livros_e_abreviaturas = LIVROS.merge(LIVROS_ABREVIADOS)

	regex_referencia = Regexp.new('(((([1-3]|[iI]{1,3})( )?)?([a-zá-úà-ùâ-ûä-üçA-ZÁ-ÚÀ-ÙÂ-ÛÄ-ÜÇ]+))[ ]?((\d{1,3})((:|-|,|\.)( )?(\d{1,3}))*))')
	
	comentario_formatado = comentario.dup
	
	comentario_formatado.gsub!(regex_referencia) do |match|
		referencia = $1
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
			reticencias = ''
			if ver == ''
				ver = 1
				reticencias = ' (...)'
			end
			livro = Livro.where(:permalink => nome_deste_livro).first
			capitulo = livro.capitulos.where(:numero => cap).first
			if capitulo != nil
				versiculo = capitulo.versiculos.where(:numero => ver).first
			else
				versiculo = nil
			end
			
			if versiculo != nil
				texto_versiculo = versiculo.texto + reticencias
				@@referencias << {:versiculo_citado => versiculo, :ref => referencia}
				'<a title="' + texto_versiculo + '" href="/'+ nome_deste_livro + url_fim + '">' + referencia +'</a>'
			else
				match
			end
		else #não é uma referência
			match
		end
	end

	return comentario_formatado
  end

  def self.get_referencias
	@@referencias
  end
  
  def self.get_links
	@@links
  end

end
