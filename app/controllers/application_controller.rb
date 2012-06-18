# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def precisa_de_login
    if current_user.nil?
      flash[:notice] = "Você precisa se logar para acessar esta área!"
      redirect_to new_user_session_path
    end
  end

  private
  def after_sign_in_path_for(resource_or_scope)
    '/mural'
  end
end
