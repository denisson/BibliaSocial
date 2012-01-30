require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  setup :inicializar
  
  test "Link solto" do
	url = "http://ministerioelshamah.com/"
	
	@link = Link.create_link(@user, @versiculo, url)

	assert_equal url, @link.url
	assert_equal "Ministério El Shamah | ", @link.titulo
	assert_equal nil, @link.comment
	assert_equal @comment, @link.comment_item
  end
  
  test "Link com comentário" do
	url = "http://youtu.be/8uBU2CzisEQ"
	texto = "texto do comentário"
	
	@comment = Comment.create_comment_link(@user, @versiculo, texto, url)
	assert_equal texto, @comment.texto
	assert_equal texto, @comment.texto_html
	assert_equal 0, @comment.links.size
	assert_equal 0, @comment.referencias.size
	assert_equal 1, @comment.videos.size
	
	@video = @comment.item
	assert_equal url, @video.link_url	
	assert_equal "http://i1.ytimg.com/vi/8uBU2CzisEQ/hqdefault.jpg", @video.thumb_url
	assert_equal "Evangelho segundo o twitter", @video.titulo
	assert_equal "http://www.youtube.com/v/8uBU2CzisEQ?version=3&autohide=1", @video.player_url
	assert_equal nil, @video.comment
	assert_equal @comment, @video.comment_item
	
  end
  
  def inicializar
	@versiculo = versiculos(:genesis)
	@user = users(:eu)
  end
  
  def criar_link(href, texto)
	return '<a href="'+href+'" target="_blank">'+texto+'</a>'
  end
  
end
