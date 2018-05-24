class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!
def get_role_from_url
  #gets the users role relative to the cohort specified in the url
  puts "99999999999999999"
  #edge case because params[:id] changes with nested routes
  cohort_id = /group_invitations/.match(request.original_url) ? params[:cohort_id] : params[:id]

  @user_role = get_role(cohort_id, current_user.id)
end

def get_role(cohort_id, user_id)
  if user_cohort_association = CohortUser.where(cohort_id: cohort_id, user_id: user_id).first
    user_role = user_cohort_association.user_role
  end
end

def is_admin?(cohort_id, user_id)
  return get_role(cohort_id, user_id) == 'admin'
end

def is_student?(cohort_id, user_id)
  return get_role(cohort_id, user_id) == 'student'
end

def bounce_if_not_logged_in
  if !user_signed_in?
    redirect_to '/'
  end
end


  
  

end
