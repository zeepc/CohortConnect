class GroupInvitationsController < ApplicationController
  before_action :set_group_invitation, only: [:show, :edit, :update, :destroy]

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

  # POST /group_invitations
  # POST /group_invitations.json
  def create
    @group_invitation = GroupInvitation.new(group_invitation_params)

    respond_to do |format|
      if @group_invitation.save
        format.html { redirect_to @group_invitation, notice: 'Group invitation was successfully created.' }
        format.json { render :show, status: :created, location: @group_invitation }
      else
        format.html { render :new }
        format.json { render json: @group_invitation.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:group_invitation).permit(:sent_by_id, :user_id, :group_id, :accepted?, :admin_approved?)
    end
end
