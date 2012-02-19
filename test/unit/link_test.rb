require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  setup :inicializar
  
  test "Link solto" do
    url = "http://ministerioelshamah.com/"

    @link = Link.criar({:user => @user, :versiculo => @versiculo, :url => url})
    assert_equal url, @link.url
    assert_equal "Ministério El Shamah | ", @link.titulo
    assert_equal nil, @link.comment
  end
  
  test "Link com comentário" do
    url = "http://youtu.be/8uBU2CzisEQ"
    texto = "texto do comentário"

    @link = Link.criar_com_comment({:user => @user, :versiculo => @versiculo, :url => url}, texto)
    assert_equal url, @link.link_url
    assert_equal "http://i1.ytimg.com/vi/8uBU2CzisEQ/hqdefault.jpg", @link.thumb_url
    assert_equal "Evangelho segundo o twitter", @link.titulo
    assert_equal "http://www.youtube.com/v/8uBU2CzisEQ?version=3&autohide=1", @link.player_url

    @comment = @link.comment
    assert_equal texto, @comment.texto
    assert_equal texto, @comment.texto_html
    assert_equal 0, @comment.links.size
    assert_equal 0, @comment.referencias.size
    assert_equal 1, @comment.videos.size
  end
  
  def inicializar
	@versiculo = versiculos(:genesis)
	@user = users(:eu)
  end
  
  def criar_link(href, texto)
	return '<a href="'+href+'" target="_blank">'+texto+'</a>'
  end
  
end
