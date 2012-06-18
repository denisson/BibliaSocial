namespace :email do
  desc "Envia email com atualizacoes semanais"
  task :semanal => :environment  do
    user = User.find_all_by_email('dap.tci@gmail.com').first

    UserMailer.notificar(user, "Notificacaoo de q ganhou na loteria \0/").deliver

  end
end