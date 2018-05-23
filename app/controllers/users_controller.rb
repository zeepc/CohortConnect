class UsersController < ApplicationController
  before_action :bounce_if_not_logged_in, only: [:home, :destroy, :profile]
  before_action :set_user, only: [:update, :destroy, :profile]
  

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/profile
  # DELETE /users/profile
  def destroy
    puts 555555
    if @user.id == current_user.id
      puts @user.first_name
      @user.destroy
      respond_to do |format|
        format.js {redirect_to '/', notice: 'Your account was successfully deleted.'}
      end
    else
      puts "Cannot delete someone elses account"
    end
  end

  #GET /
  def login
    if current_user
      redirect_to '/users/profile'
    end
  end

  # GET /users/profile
  def profile
    @all_cohorts = @user.cohorts.all
    @admin_cohorts = Cohort.joins(:cohort_users).where(cohort_users: {user_id: current_user.id, user_role: "admin"})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :profile_image_url, :profile_link_url, :current_employer, :current_title, :location)
    end
end
