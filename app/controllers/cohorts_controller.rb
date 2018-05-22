class CohortsController < ApplicationController
  before_action :set_cohort, only: [:show, :edit, :update, :destroy]
  before_action :get_role_from_url

  # GET /cohorts
  # GET /cohorts.json
  def index
    @cohorts = Cohort.all
  end

  # GET /cohorts/1
  # GET /cohorts/1.json
  def show
    @cohort_id = params[:id]
    if cohort = Cohort.find_by_id(@cohort_id)
      @admins = cohort.users.where()
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

    if current_user_id = current_user.id
      @cohort = Cohort.new(cohort_params)

      respond_to do |format|
        if @cohort.save
          CohortUser.create(cohort_id: @cohort.id, user_id: current_user_id, user_role: 'admin')
          format.html { redirect_to @cohort, notice: 'Cohort was successfully created.' }
          format.json { render :show, status: :created, location: @cohort }
        else
          format.html { render :new }
          format.json { render json: @cohort.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to 
    end
  end

  # PATCH/PUT /cohorts/1
  # PATCH/PUT /cohorts/1.json
  def update
    respond_to do |format|
      if @cohort.update(cohort_params)
        format.html { redirect_to @cohort, notice: 'Cohort was successfully updated.' }
        format.json { render :show, status: :ok, location: @cohort }
      else
        format.html { render :edit }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohorts/1
  # DELETE /cohorts/1.json
  def destroy
    @cohort.destroy
    respond_to do |format|
      format.html { redirect_to cohorts_url, notice: 'Cohort was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #DELETE /users/remove_from_cohort
  def remove_from_cohort
    #if passed user id = current user id or current user is admin of specified cohort
    if cohort_params[:user_id] == current_user.id || current_user.cohorts(cohort_params[:cohort_id]).user_role == "admin"
      User.find(cohort_params[:user_id]).cohorts.delete(Cohort.find(params[:cohort_id]))
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort
      @cohort = Cohort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cohort_params
      params.require(:cohort).permit(:name, :start_date, :end_date, :cohort_id)
    end
end
