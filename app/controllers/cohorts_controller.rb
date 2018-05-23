class CohortsController < ApplicationController
  before_action :set_cohort, only: [:show, :edit, :update, :destroy]

  before_action :bounce_if_not_logged_in, only: [:new, :create, :update, :destroy]
  before_action :get_role_from_url, only: [:show, :edit, :update, :destroy], if: -> { current_user }



  # GET /cohorts
  # GET /cohorts.json
  def index
    @cohorts = Cohort.all
    render layout: "login"
  end

  # GET /cohorts/1
  # GET /cohorts/1.json
  def show

    @user = current_user

    @cohort_id = params[:id]
    if cohort = Cohort.find_by_id(@cohort_id)
      @admins = User.joins(:cohort_users).where(cohort_users: {cohort_id: @cohort_id, user_role: "admin"}) 
      @students = User.joins(:cohort_users).where(cohort_users: {cohort_id: @cohort_id, user_role: "student"}) 
    else
      puts "No Cohorts found"
    end
  end

  # GET /cohorts/new
  def new
    
    @cohort = Cohort.new
  end

  # GET /cohorts/1/edit
  def edit
  end

  # POST /cohorts
  # POST /cohorts.json
  def create
    @cohort = Cohort.new(name: cohort_params[:name], start_date: cohort_params[:start_date], end_date: cohort_params[:end_date], description: cohort_params[:description])

    respond_to do |format|
      if @cohort.save
        CohortUser.create(cohort_id: @cohort.id, user_id: current_user.id, user_role: 'admin')
        format.js { puts 'Cohort was successfully created.' }
        format.html { redirect_to @cohort, notice: 'Cohort was successfully created.' }
        format.json { render :show, status: :created, location: @cohort }
      else
        format.html { render :new }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
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

  #DELETE /cohorts/remove_user_from_cohort
  def remove_user_from_cohort
    # if passed user id belongs to current user or current user is admin of specified cohort
    if cohort_params[:user_id] == current_user.id || get_role(cohort_params[:cohort_id], current_user.id) == "admin"
      User.find(cohort_params[:user_id]).cohorts.delete(Cohort.find(cohort_params[:cohort_id]))
    end
  end

  #PUT /cohorts/add_user_to_admin
  def add_user_to_admin
    if is_admin?(cohort_params[:cohort_id], current_user.id)
      User.find(cohort_params[:user_id]).cohort_users.find_by(cohort_id: cohort_params[:cohort_id]).update(user_role: 'admin')
    end
  end

  #GET /cohorts/:id/pending_requests
  def pending_requests
    if is_admin?(params[:id], current_user.id)
      @pending_requests = GroupInvitation.where(admin_approved?: false, group_id: params[:id])
      @cohorts = []
    end
    render 'index'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort
      @cohort = Cohort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cohort_params

      params.require(:cohort).permit(:name, :start_date, :end_date, :description, :cohort_id, :user_id)

    end
end
