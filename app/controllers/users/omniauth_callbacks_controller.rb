class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      #flash[:notice] = "autenticado!"
      sign_in @user, :event => :authentication
      if request.env['omniauth.origin'] == root_url
        redirect_to mural_path
      else
        redirect_to request.env['omniauth.origin'] || mural_path
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end