# encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "noreply@bibliasocial.com"

  def notificar_seguidor_novo(user, seguidor_novo)
    @seguidor = seguidor_novo
    mail(:to => "#{user.nome} <#{user.email}>", :subject => "#{@seguidor.nome} agora está seguindo você na BibliaSocial!" )
  end

  def notificar_voto(voto)
    @voto = voto
    @item = voto.votavel
    acao_voto = voto.like? ? "gostou" : "não gostou"
    @acao = "#{acao_voto} #{@item.class.descricao_atividade_email}"
    mail(:to => "#{@item.user.nome} <#{@item.user.email}>", :subject => "#{@voto.user.nome} #{@acao}.")
  end
end