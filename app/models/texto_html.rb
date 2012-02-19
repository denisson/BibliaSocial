class TextoHtml
 
  attr_accessor :referencias, :links, :texto
  
  def initialize(texto)
	@texto = texto.dup.to_str # de acordo com essa solução https://github.com/rails/rails/issues/1744#issuecomment-1405503
	@referencias = Array.new
	@links = Array.new
	formatar
  end
  
  def formatar_links
	@texto.gsub!(Link.regex) do |match|
		if $1 == nil
			url = "http://" + match
		else
			url = match	
		end
		@links << url
		'<a href="'+url+'" target="_blank">'+match+'</a>'
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
