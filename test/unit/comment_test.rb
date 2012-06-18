require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup :inicializar

  test "comentário sem usuário" do
    texto = "Teste de comentário"

    @comment = Comment.criar({:versiculo => @versiculo, :texto => texto})

    assert_equal 1, @comment.errors.size
  end

  test "comentário puro e simples" do
    texto = "Teste de comentário"

    @comment = Comment.criar({:user => @user, :texto => texto})

    #efeito no comentário
    assert_equal texto, @comment.texto
    assert_equal texto, @comment.texto_html
    assert_equal @user.id, @comment.user_id
    assert_equal nil, @comment.versiculo_id
    assert_equal nil, @comment.item
    assert_equal 0, @comment.links.size
    assert_equal 0, @comment.referencias.size
    assert_equal 0, @comment.videos.size
    assert_equal 0, @comment.likes.size
    assert_equal 0, @comment.dislikes.size
    assert_equal 0, @comment.atividades_dependentes.size
    #efeito nas Atividades
    @atividade = @comment.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal nil, @atividade.versiculo_id
    assert_equal @comment, @atividade.item
    #efeito no usuário
    assert_equal 0, @user.links.size
    assert_equal 0, @user.referencias.size
    assert_equal 0, @user.videos.size
    assert_equal 1, @user.comments.size
    assert_equal 0, @user.citacoes.size
    assert_equal 1, @user.atividades.size
    assert_equal 1, @user.atividades_count

  end

  test "comentário vinculodo a um versiculo" do
    texto = "Teste de comentário"

    @comment = Comment.criar({:user => @user, :versiculo => @versiculo, :texto => texto})
    @versiculo.reload
    #efeito no comentário
    assert_equal texto, @comment.texto
    assert_equal texto, @comment.texto_html
    assert_equal @user.id, @comment.user_id
    assert_equal @versiculo.id, @comment.versiculo_id
    assert_equal nil, @comment.item
    assert_equal 0, @comment.links.size
    assert_equal 0, @comment.referencias.size
    assert_equal 0, @comment.videos.size
    assert_equal 0, @comment.likes.size
    assert_equal 0, @comment.dislikes.size
    #efeito no versículo
    assert_equal 0, @versiculo.links.size
    assert_equal 0, @versiculo.referencias.size
    assert_equal 0, @versiculo.videos.size
    assert_equal 1, @versiculo.comments.size
    assert_equal 0, @versiculo.citacoes.size
    assert_equal 1, @versiculo.atividades.size
    #assert_equal @comment.created_at, @versiculo.last_atividade_at
    #efeito nas Atividades
    @atividade = @comment.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal @versiculo.id, @atividade.versiculo_id
    assert_equal @comment, @atividade.item
    #efeito no usuário
    assert_equal 0, @user.links.size
    assert_equal 0, @user.referencias.size
    assert_equal 0, @user.videos.size
    assert_equal 1, @user.comments.size
    assert_equal 0, @user.citacoes.size
    assert_equal 1, @user.atividades.size
    assert_equal 1, @user.atividades_count

  end
  
  test "comentário com um link" do
    texto = "http://ministerioelshamah.com/"

    @comment = Comment.criar({:user => @user, :versiculo => @versiculo, :texto => texto})
    @versiculo.reload
    #efeito no comentário
    assert_equal texto, @comment.texto
    assert_equal criar_link(texto, texto), @comment.texto_html
    assert_equal @user.id, @comment.user_id
    assert_equal @versiculo.id, @comment.versiculo_id
    assert_equal nil, @comment.item
    assert_equal 1, @comment.links.size
    assert_equal 0, @comment.referencias.size
    assert_equal 0, @comment.videos.size
    assert_equal 0, @comment.likes.size
    assert_equal 0, @comment.dislikes.size
    #efeito no versículo
    assert_equal 1, @versiculo.links.size
    assert_equal 0, @versiculo.referencias.size
    assert_equal 0, @versiculo.videos.size
    assert_equal 1, @versiculo.comments.size
    assert_equal 0, @versiculo.citacoes.size
    assert_equal 1, @versiculo.atividades.size
    #assert_equal @comment.created_at, @versiculo.last_atividade_at
    #efeito nas Atividades
    @atividade = @comment.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal @versiculo.id, @atividade.versiculo_id
    assert_equal @comment, @atividade.item
    #efeito no usuário
    assert_equal 1, @user.links.size
    assert_equal 0, @user.referencias.size
    assert_equal 0, @user.videos.size
    assert_equal 1, @user.comments.size
    assert_equal 0, @user.citacoes.size
    assert_equal 1, @user.atividades.size
    assert_equal 1, @user.atividades_count
    #efeito no Link
    @link = @comment.links.first
    assert_equal texto, @link.url
    assert_equal "Ministério El Shamah | ", @link.titulo
    assert_equal @comment, @link.comment
    assert_equal nil, @link.comment_descricao
    assert_equal @user.id, @link.user_id
    assert_equal @versiculo.id, @link.versiculo_id
    assert_equal nil, @link.atividade

  end
  
  test "comentário com um video" do
    texto = "http://youtu.be/8uBU2CzisEQ"

    @comment = Comment.criar({:user => @user, :versiculo => @versiculo, :texto => texto})
    @versiculo.reload
    #efeito no comentário
    assert_equal texto, @comment.texto
    assert_equal criar_link(texto, texto), @comment.texto_html
    assert_equal @user.id, @comment.user_id
    assert_equal @versiculo.id, @comment.versiculo_id
    assert_equal nil, @comment.item
    assert_equal 0, @comment.links.size
    assert_equal 0, @comment.referencias.size
    assert_equal 1, @comment.videos.size
    assert_equal 0, @comment.likes.size
    assert_equal 0, @comment.dislikes.size
    #efeito no versículo
    assert_equal 0, @versiculo.links.size
    assert_equal 0, @versiculo.referencias.size
    assert_equal 1, @versiculo.videos.size
    assert_equal 1, @versiculo.comments.size
    assert_equal 0, @versiculo.citacoes.size
    assert_equal 1, @versiculo.atividades.size
    #assert_equal @comment.created_at, @versiculo.last_atividade_at
    #efeito nas Atividades
    @atividade = @comment.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal @versiculo.id, @atividade.versiculo_id
    assert_equal @comment, @atividade.item
    #efeito no usuário
    assert_equal 0, @user.links.size
    assert_equal 0, @user.referencias.size
    assert_equal 1, @user.videos.size
    assert_equal 1, @user.comments.size
    assert_equal 0, @user.citacoes.size
    assert_equal 1, @user.atividades.size
    assert_equal 1, @user.atividades_count
    #efeito no Link
    @video = @comment.videos.first
    assert_equal texto, @video.link_url
    assert_equal "http://i1.ytimg.com/vi/8uBU2CzisEQ/hqdefault.jpg", @video.thumb_url
    assert_equal "Evangelho segundo o twitter", @video.titulo
    assert_equal "http://www.youtube.com/v/8uBU2CzisEQ?version=3&autohide=1", @video.player_url
    assert_equal @comment, @video.comment
    assert_equal nil, @video.comment_descricao
    assert_equal @user.id, @video.user_id
    assert_equal @versiculo.id, @video.versiculo_id
    assert_equal nil, @video.atividade

  end
  
  test "comentario com referencia" do
    texto = "Jo 12:24-26"
    texto_versiculo = "texto do versiculo de joao"
    @versiculo_citado = versiculos(:joao)

    @comment = Comment.criar({:user => @user, :versiculo => @versiculo, :texto => texto})
    @versiculo_citado.reload
    @versiculo.reload
    #efeito no comentário
    assert_equal texto, @comment.texto
    assert_equal '<a title="' +texto_versiculo+'" href="/joao/12/24">'+texto+'</a>', @comment.texto_html
    assert_equal @user.id, @comment.user_id
    assert_equal @versiculo.id, @comment.versiculo_id
    assert_equal nil, @comment.item
    assert_equal 0, @comment.links.size
    assert_equal 1, @comment.referencias.size
    assert_equal 0, @comment.videos.size
    assert_equal 0, @comment.likes.size
    assert_equal 0, @comment.dislikes.size
    #efeito no versículo
    assert_equal 0, @versiculo.links.size
    assert_equal 1, @versiculo.referencias.size
    assert_equal 0, @versiculo.videos.size
    assert_equal 1, @versiculo.comments.size
    assert_equal 0, @versiculo.citacoes.size
    assert_equal 1, @versiculo.atividades.size
      #assert_equal @comment.created_at, @versiculo.last_atividade_at
    #efeito nas Atividades
    @atividade = @comment.atividade
    assert_equal @user.id, @atividade.user_id
    assert_equal @versiculo.id, @atividade.versiculo_id
    assert_equal @comment, @atividade.item
    assert_equal 2, Atividade.count
    #efeito no usuário
    assert_equal 0, @user.links.size
    assert_equal 1, @user.referencias.size
    assert_equal 0, @user.videos.size
    assert_equal 1, @user.comments.size
    assert_equal 1, @user.citacoes.size
    assert_equal 2, @user.atividades.size
    assert_equal 2, @user.atividades_count
    #efeito na Referência
    @referencia = @comment.referencias.first
    assert_equal texto, @referencia.ref
    assert_equal "João 12:24-26", @referencia.pretty_ref
    assert_equal @versiculo_citado, @referencia.versiculo_citado
    assert_equal @comment, @referencia.comment
    assert_equal nil, @referencia.comment_descricao
    assert_equal @user.id, @referencia.user_id
    assert_equal @versiculo.id, @referencia.versiculo_id
    assert_equal nil, @referencia.atividade
    assert_not_equal nil, @referencia.citacao
    #efeito no Versículo Citado
    assert_equal 0, @versiculo_citado.links.size
    assert_equal 0, @versiculo_citado.referencias.size
    assert_equal 0, @versiculo_citado.videos.size
    assert_equal 0, @versiculo_citado.comments.size
    assert_equal 1, @versiculo_citado.citacoes.size
    assert_equal 1, @versiculo_citado.atividades.size
    #efeito na citação
    @citacao = @versiculo_citado.citacoes.first
    assert_equal @user, @citacao.user
    assert_equal "Gênesis 1:1", @citacao.pretty_ref
    assert_equal @versiculo, @citacao.versiculo_origem
    assert_equal @versiculo_citado, @citacao.versiculo
    assert_equal @comment, @citacao.comment
    assert_equal nil, @citacao.comment_descricao
    assert_not_equal nil, @citacao.atividade
    assert_equal @referencia, @citacao.referencia
    #efeito na atividade da citação
    @atividade_citacao = @citacao.atividade
    assert_equal @user.id, @atividade_citacao.user_id
    assert_equal @versiculo_citado.id, @atividade_citacao.versiculo_id
    assert_equal @citacao, @atividade_citacao.item

  end
  
  def inicializar
    @versiculo = versiculos(:genesis)
    @user = users(:eu)
  end

  def criar_link(href, texto)
    return '<a href="'+href+'" target="_blank">'+texto+'</a>'
  end
end