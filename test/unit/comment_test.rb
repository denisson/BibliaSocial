require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup :inicializar
  
  test "comentário sem links refs e videos" do
	texto = "Teste de comentário"
	
	@comment = Comment.create_comment(@user, @versiculo, texto)
	assert_equal texto, @comment.texto
	assert_equal texto, @comment.texto_html
	assert_equal 0, @comment.links.size
	assert_equal 0, @comment.referencias.size
	assert_equal 0, @comment.videos.size
  end
  
  test "comentário com um link" do
	texto = "http://ministerioelshamah.com/"
	
	@comment = Comment.create_comment(@user, @versiculo, texto)
	assert_equal texto, @comment.texto
	assert_equal criar_link(texto, texto), @comment.texto_html
	assert_equal 1, @comment.links.size
	assert_equal 0, @comment.referencias.size
	assert_equal 0, @comment.videos.size
	
	@link = @comment.links.first
	assert_equal texto, @link.url
	assert_equal "Ministério El Shamah | ", @link.titulo
  end
  
  test "comentário com um video" do
	texto = "http://youtu.be/8uBU2CzisEQ"
	
	@comment = Comment.create_comment(@user, @versiculo, texto)
	assert_equal texto, @comment.texto
	assert_equal criar_link(texto, texto), @comment.texto_html
	assert_equal 0, @comment.links.size
	assert_equal 0, @comment.referencias.size
	assert_equal 1, @comment.videos.size
	
	@video = @comment.videos.first
	assert_equal texto, @video.link_url	
	assert_equal "http://i1.ytimg.com/vi/8uBU2CzisEQ/hqdefault.jpg", @video.thumb_url
	assert_equal "Evangelho segundo o twitter", @video.titulo
	assert_equal "http://www.youtube.com/v/8uBU2CzisEQ?version=3&autohide=1", @video.player_url
  end
  
  test "comentario com referencia" do
	texto = "Jo 12:24-26"
	texto_versiculo = "texto do versiculo de joao"
	
	@comment = Comment.create_comment(@user, @versiculo, texto)
	assert_equal texto, @comment.texto
	assert_equal '<a title="' +texto_versiculo+'" href="/joao/12/24">'+texto+'</a>', @comment.texto_html
	assert_equal 0, @comment.links.size
	assert_equal 1, @comment.referencias.size
	assert_equal 0, @comment.videos.size
	
	@referencia = @comment.referencias.first
	assert_equal texto, @referencia.ref
	assert_equal versiculos(:joao), @referencia.versiculo_citado
  end
 
  
  def inicializar
	@versiculo = versiculos(:genesis)
	@user = users(:eu)
  end
  
  def criar_link(href, texto)
	return '<a href="'+href+'" target="_blank">'+texto+'</a>'
  end
end
