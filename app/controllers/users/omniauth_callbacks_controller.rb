class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth = request.env["omniauth.auth"]
    identity = User.where(provider: auth.provider, uid: auth.uid).first
    
    
    if identity
      @user = identity
    else
      token = session[:invitation_token]
      if token && user = User.find_by_invitation_token(token, true)
        # puts "555555"
        # puts "successfully got user from inite token in omniauth controller"
      else
        user = User.new
      end

      user.from_omniauth(auth)
      if user.valid?
        if user.valid_invitation?
          user.accept_invitation!
        else
          user.save
        end
        @user = user
      else
        # user.save
        # puts user.errors.full_messages
        # puts "555555"
        # puts "something went wrong in creating user"
      end
    end
    session[:invitation_token] = nil

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
