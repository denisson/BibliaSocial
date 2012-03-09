class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def notificar(user, notificacao)
    @notificacao = notificacao
    mail(:to => "#{user.nome} <#{user.email}>", :subject => notificacao )
  end
end