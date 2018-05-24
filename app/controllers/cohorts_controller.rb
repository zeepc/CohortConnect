class CohortsController < ApplicationController
  before_action :set_cohort, only: [:show, :update, :destroy]

  before_action :bounce_if_not_logged_in, only: [:create, :update, :destroy]
  before_action :get_role_from_url, only: [:show, :update, :destroy], if: -> { current_user }

  # GET /cohorts/1
  # GET /cohorts/1.json
  def show
    @user = current_user
<<<<<<< HEAD
  
=======
    pending_requests()

>>>>>>> master
    @cohort_id = params[:id]
    if cohort = Cohort.find_by_id(@cohort_id)
      @admins = User.joins(:cohort_users).where(cohort_users: {cohort_id: @cohort_id, user_role: "admin"}) 
      @students = User.joins(:cohort_users).where(cohort_users: {cohort_id: @cohort_id, user_role: "student"}) 
    else
      puts "No Cohorts found"
    end
  end


  # POST /cohorts
  # POST /cohorts.json
  def create
    @cohort = Cohort.new(name: cohort_params[:name], start_date: cohort_params[:start_date], end_date: cohort_params[:end_date], description: cohort_params[:description])
    puts cohort_params
    puts "444444"
    respond_to do |format|
      if @cohort.save
        CohortUser.create(cohort_id: @cohort.id, user_id: current_user.id, user_role: 'admin')
        format.js { puts 'Cohort was successfully created.' }
      else
        format.js { puts 'Cohort was not created.' }
      end
    end

    if cohort_params[:emails].length > 1
      options = {group_id: @cohort.id, emails: cohort_params[:emails], sent_by_id: current_user.id}
      puts "5555"
      puts options.inspect
      process_invites(options)
    end
  end

  # PATCH/PUT /cohorts/1
  # PATCH/PUT /cohorts/1.json
  def update

    if @user_role == 'admin'
      respond_to do |format|
        if @cohort.update(name: cohort_params[:name], start_date: cohort_params[:start_date], end_date: cohort_params[:end_date], description: cohort_params[:description])
          format.js {puts "successfully updated cohort through js"}
          format.html { redirect_to @cohort, notice: 'Cohort was successfully updated.' }
          format.json { render :show, status: :ok, location: @cohort }
        else
          format.js {puts "unsuccessfully updated cohort through js"}
          format.html { render :edit }
          format.json { render json: @cohort.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /cohorts/1
  # DELETE /cohorts/1.json
  def destroy
    if @user_role == 'admin'
      @cohort.destroy
      respond_to do |format|
        format.html { redirect_to cohorts_url, notice: 'Cohort was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  #DELETE /cohorts/:cohort_id/user/:user_id/remove_user_from_cohort
  def remove_user_from_cohort
    # if passed user id belongs to current user or current user is admin of specified cohort
    if params[:user_id] == current_user.id || get_role(params[:cohort_id], current_user.id) == "admin"
      User.find(params[:user_id]).cohorts.delete(Cohort.find(params[:cohort_id]))
    end
  end

  #PUT /cohorts/:cohort_id/user/:user_id/add_user_to_admin
  def add_user_to_admin
    if is_admin?(params[:cohort_id], current_user.id)
      CohortUser.find_by(cohort_id: params[:cohort_id], user_id: params[:user_id]).update(user_role: 'admin')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort
      @cohort = Cohort.find(params[:id])
    end

    def pending_requests
      if is_admin?(params[:id], current_user.id)
        @pending_users = User.joins(:group_invitations).where(group_invitations: {admin_approved?: false, group_id: params[:id]})
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cohort_params

      params.require(:cohort).permit(:emails, :name, :start_date, :end_date, :description, :cohort_id, :user_id)

    end
end
