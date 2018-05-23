class GroupInvitationsController < ApplicationController
  before_action :set_group_invitation, only: [:destroy]
  before_action :bounce_if_not_logged_in
  before_action :get_role_from_url
  
  
  #POST /invites
  def invites
    emails = group_invitation_params[:emails].split(',').map {|email| email.strip}
    #emails = ENV['EMAILS'].split(',').map {|email| email.strip}

    emails.each do |email|

      #if the user does not exists, invite them into the app. 
      #if the user does exist and they are already in the cohort or already invited to the cohort, skip inviting them.
      if !user = User.find_by(email: email)
        User.invite!({email: email})
      elsif user.cohorts.find_by_id(group_invitation_params[:group_id]) || user.group_invitations.find_by(user_id: user.id)
        next
      end

      create_invitation(email)
    end
  end

  # POST /group_invitations
  # POST /group_invitations.json
  def create
    create_invitation(group_invitation_params[:email])

    respond_to do |format|
        format.js { puts "successfully created invite " }

    end

    # if current_user && user_cohort_association = CohortUser.where(cohort_id: group_invitation_params[:group_id], user_id: current_user.id)[0]
    #   @user_role = user_cohort_association.user_role
    # end
    

    # user_id = group_invitation_params[:user_id] != "" ? group_invitation_params[:user_id] : User.find_by(email: group_invitation_params[:email]).id

    # if @group_invitation = GroupInvitation.where(group_id: group_invitation_params[:group_id], user_id: user_id).first
    # else 
    #   @group_invitation = GroupInvitation.new(group_id: group_invitation_params[:group_id], user_id: user_id, sent_by_id: group_invitation_params[:sent_by_id])
    # end

    # field_to_update = @user_role == "admin" ? :admin_approved? : :accepted? 

    # if @group_invitation.update(field_to_update => true)
    #   puts "successfully created an invite to cohort #{group_invitation_params[:group_id]} for user #{}"
    # end

    
  end

  # DELETE /group_invitations/1
  # DELETE /group_invitations/1.json
  def destroy
    if group_invitation = GroupInvitation.find_by(user_id: group_invitation_params[:email], group_id: group_invitation_params[:cohort_id])
      group_invitation.destroy

      respond_to do |format|
        format.js {puts "invite by js"}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_invitation
      @group_invitation = GroupInvitation.find_by(user_id: group_invitation_params[:email], group_id: group_invitation_params[:cohort_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_invitation_params
      params.require(:group_invitation).permit(:emails, :email, :sent_by_id, :user_id, :group_id, :accepted?, :admin_approved?, :cohort_id)
    end

    def create_invitation(email = "not an email")

      puts "enetered create invitation"
      if current_user && user_cohort_association = CohortUser.where(cohort_id: group_invitation_params[:group_id], user_id: current_user.id)[0]
        @user_role = user_cohort_association.user_role
      end

      user_id = group_invitation_params[:user_id] != nil ? group_invitation_params[:user_id] : User.find_by(email: email).id


      if @group_invitation = GroupInvitation.where(group_id: group_invitation_params[:group_id], user_id: user_id).first
      else 
        @group_invitation = GroupInvitation.new(group_id: group_invitation_params[:group_id], user_id: user_id, sent_by_id: group_invitation_params[:sent_by_id])
      end
  
      field_to_update = @user_role == "admin" ? :admin_approved? : :accepted? 
  
      if @group_invitation.update(field_to_update => true)
        puts "successfully created an invite to cohort #{group_invitation_params[:group_id]} for user #{user_id}"
      end

      puts @group_invitation.errors.full_messages
    end
end
