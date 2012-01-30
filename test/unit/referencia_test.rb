require 'test_helper'

class ReferenciaTest < ActiveSupport::TestCase
  setup :inicializar
  
  test "Referencia sem Comentário" do
	ref = "Jo 12:24-26"
	
	@referencia = Referencia.create_referencia(@user, @versiculo, ref)

	assert_equal ref, @referencia.ref
	assert_equal versiculos(:joao), @referencia.versiculo_citado
	assert_equal nil, @referencia.comment
  end
  
  test "Referencia com comentário" do
	ref = "Jo 12:24-26"
	texto = "texto do comentário"
	
	@comment = Comment.create_comment_referencia(@user, @versiculo, texto, ref)
	assert_equal texto, @comment.texto
	assert_equal texto, @comment.texto_html
	assert_equal 0, @comment.links.size
	assert_equal 1, @comment.referencias.size
	assert_equal 0, @comment.videos.size
	
	@referencia = @comment.item
	assert_equal ref, @referencia.ref
	assert_equal versiculos(:joao), @referencia.versiculo_citado
	assert_equal @comment, @referencia.comment
	assert_equal nil, @referencia.comment
	assert_equal @comment, @referencia.comment_item
  end
  
  def inicializar
	@versiculo = versiculos(:genesis)
	@user = users(:eu)
  end
  
  def criar_link(href, texto)
	return '<a href="'+href+'" target="_blank">'+texto+'</a>'
  end
end
