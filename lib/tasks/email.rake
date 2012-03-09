namespace :email do
  desc "Envia email com atualizacoes semanais"
  task :semanal => :environment  do

    UserMailer.notificar(current_user, "Notificacaoo de q ganhou na loteria \0/").deliver

  end
end