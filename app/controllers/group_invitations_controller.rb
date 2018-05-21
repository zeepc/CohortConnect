class GroupInvitationsController < ApplicationController
  before_action :set_group_invitation, only: [:show, :edit, :update, :destroy]
  before_action :get_role
  before_action :bounce_if_not_logged_in
  

  # GET /group_invitations
  # GET /group_invitations.json
  def index
    @group_invitations = GroupInvitation.all
  end

  # GET /group_invitations/1
  # GET /group_invitations/1.json
  def show
  end

  # GET /group_invitations/new
  def new

    @group_invitation = GroupInvitation.new
  end

  # GET /group_invitations/1/edit
  def edit
  end


  #POST /invites
  def invites
    emails = group_invitation_params[:emails].split(',').map {|email| email.strip}
    #emails = ENV['EMAILS'].split(',').map {|email| email.strip}

    emails.each do |email|

      if !User.find_by(email: email)
        User.invite!({email: email})
      end

      create_invitation(email)
    end
  end

  # POST /group_invitations
  # POST /group_invitations.json
  def create

    create_invitation(group_invitation_params[:email])
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

    # respond_to do |format|
    #   if @group_invitation.update(field_to_update => true)
    #     format.html { redirect_to @group_invitation, notice: 'Group invitation was successfully created.' }
    #     format.json { render :show, status: :created, location: @group_invitation }
    #   else
    #     @group_invitation.destroy
    #     format.html { render :new }
    #     format.json { render json: @group_invitation.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /group_invitations/1
  # PATCH/PUT /group_invitations/1.json
  def update
    respond_to do |format|
      if @group_invitation.update(group_invitation_params)
        format.html { redirect_to @group_invitation, notice: 'Group invitation was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_invitation }
      else
        format.html { render :edit }
        format.json { render json: @group_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_invitations/1
  # DELETE /group_invitations/1.json
  def destroy
    @group_invitation.destroy
    respond_to do |format|
      format.html { redirect_to group_invitations_url, notice: 'Group invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_invitation
      @group_invitation = GroupInvitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_invitation_params
      params.require(:group_invitation).permit(:emails, :email, :sent_by_id, :user_id, :group_id, :accepted?, :admin_approved?, :cohort_id)
    end

    def bounce_if_not_logged_in
      if !user_signed_in?
        redirect_to '/'
      end
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
