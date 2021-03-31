class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect(user)
    else
      flash.error = "Your Twitter credentials are incorrect"
      redirect_to new_user_registration_path
    end
  end

end
