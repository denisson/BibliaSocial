require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  setup :inicializar

  test "link sem usuário" do
    url = "http://ministerioelshamah.com/"

    @link = Link.criar({:url => url})

    assert_equal 1, @link.errors.size
  end

  test "Link solto e sem versículos" do
    url = "http://ministerioelshamah.com/"

    @link = Link.criar({:user => @user, :url => url})
    #efeito no link
    assert_equal url, @link.url
    assert_equal "Ministério El Shamah | ", @link.titulo
    assert_equal nil, @link.comment
    assert_equal nil, @link.comment_descricao
    assert_equal @user.id, @link.user_id
    assert_equal nil, @link.versiculo_id
    assert_equal 0, @link.likes.size
    assert_equal 0, @link.dislikes.size
    assert_equal 0, @link.atividades_dependentes.size
    #efeito nas Atividades
    @atividade = @link.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal nil, @atividade.versiculo_id
    assert_equal @link, @atividade.item
    #efeito no usuário
    #assert_equal 1, @user.atividades.size
  end

  test "Link solto vinculado a um versiculo" do
    url = "http://ministerioelshamah.com/"

    @link = Link.criar({:user => @user, :versiculo => @versiculo, :url => url})
    @versiculo.reload
    #efeito no link
    assert_equal url, @link.url
    assert_equal "Ministério El Shamah | ", @link.titulo
    assert_equal nil, @link.comment
    assert_equal nil, @link.comment_descricao
    assert_equal @user.id, @link.user_id
    assert_equal @versiculo.id, @link.versiculo_id
    assert_equal 0, @link.likes.size
    assert_equal 0, @link.dislikes.size
    assert_equal 0, @link.atividades_dependentes.size
    #efeito nas Atividades
    @atividade = @link.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal @versiculo.id, @atividade.versiculo_id
    assert_equal @link, @atividade.item
    #efeito no versículo
    assert_equal 1, @versiculo.links.size
    assert_equal 0, @versiculo.referencias.size
    assert_equal 0, @versiculo.videos.size
    assert_equal 0, @versiculo.comments.size
    assert_equal 1, @versiculo.atividades.size
    #assert_equal @comment.created_at, @versiculo.last_atividade_at
    #efeito no usuário
    #assert_equal 1, @user.atividades.size
  end
  
  test "Link com comentário" do
    url = "http://youtu.be/8uBU2CzisEQ"
    texto = "texto do comentário"

    @link = Link.criar_com_comment({:user => @user, :versiculo => @versiculo, :url => url}, texto)
    assert_equal url, @link.link_url
    assert_equal "http://i1.ytimg.com/vi/8uBU2CzisEQ/hqdefault.jpg", @link.thumb_url
    assert_equal "Evangelho segundo o twitter", @link.titulo
    assert_equal "http://www.youtube.com/v/8uBU2CzisEQ?version=3&autohide=1", @link.player_url

    @comment = @link.comment_descricao
    assert_equal texto, @comment.texto
    assert_equal texto, @comment.texto_html
    assert_equal 0, @comment.links.size
    assert_equal 0, @comment.referencias.size
    assert_equal 0, @comment.videos.size
  end
  
  def inicializar
    @versiculo = versiculos(:genesis)
    @user = users(:eu)
  end
  
  def criar_link(href, texto)
    return '<a href="'+href+'" target="_blank">'+texto+'</a>'
  end
  
end

