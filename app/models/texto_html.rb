class TextoHtml
 
  attr_accessor :referencias, :links, :texto
  
  def initialize(texto)
	@texto = texto.dup
	@referencias = Array.new
	@links = Array.new
	formatar
  end
  
  def formatar_links
	@texto.gsub!(URI.regexp) do |match|
		@links << match
		'<a href="'+match+'" target="_blank">'+match+'</a>'
	end
  end
  
  def formatar_referencias
  
	@texto.gsub!(Referencia.regex) do |match|
		referencia = Referencia.build_referencia(match)
		
		if referencia != nil
			@referencias << referencia
			'<a title="' + referencia.versiculo_citado.texto + '" href="' + referencia.versiculo_citado.url + '">' + referencia.ref + '</a>'
		else
			match
		end
	end
  end

  def formatar
	formatar_links
	formatar_referencias
  end

end
