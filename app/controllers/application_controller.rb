class ApplicationController < ActionController::Base

  # before_action :authenticate_user!
def get_role_from_url

  #gets the users role relative to the cohort specified in the url

  #edge case because params[:id] changes with nested routes
  cohort_id = /group_invitations/.match(request.original_url) ? params[:cohort_id] : params[:id]

  # if current_user && user_cohort_association = CohortUser.where(cohort_id: cohort_id, user_id: current_user.id)[0]
  #   @user_role = user_cohort_association.user_role
  # end

  @user_role = get_role(cohort_id, current_user.id)
end

def get_role(cohort_id, user_id)
  if current_user && user_cohort_association = CohortUser.where(cohort_id: cohort_id, user_id: user_id).first
    user_role = user_cohort_association.user_role
  end

  return user_role
end


  
  

end
