class InvitationsController < Devise::InvitationsController

  #When the user clicks the email link, they are directed to our website. This controller grabs the inivitation token and stores it in the session for us to process whenever we need it (eg when they return from linked in)
  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    if params[:invitation_token] && self.resource = resource_class.find_by_invitation_token(params[:invitation_token], true)
      session[:invitation_token] = params[:invitation_token]
      redirect_to '/users/auth/linkedin'
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      session[:invitation_token] = nil
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end
end