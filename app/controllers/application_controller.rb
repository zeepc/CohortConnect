class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!
  def get_role_from_url
    #gets the users role relative to the cohort specified in the url
    #edge case because params[:id] changes with nested routes
    cohort_id = /group_invitations/.match(request.original_url) ? params[:cohort_id] : params[:id]

    @user_role = get_role(cohort_id, current_user.id)
  end

  def get_role(cohort_id, user_id)
    if user_cohort_association = CohortUser.find_by(cohort_id: cohort_id, user_id: user_id)
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

  def create_invitation(options, email = "not an email")
    puts "entered create invitation"
    @user_role = get_role(options[:group_id], current_user.id)
    user_id = options[:user_id] != nil ? options[:user_id] : User.find_by(email: email).id

    if @group_invitation = GroupInvitation.find_by(group_id: options[:group_id], user_id: user_id)
    else 
      @group_invitation = GroupInvitation.new(group_id: options[:group_id], user_id: user_id, sent_by_id: options[:sent_by_id])
    end

    field_to_update = @user_role == "admin" ? :admin_approved? : :accepted? 
    if @group_invitation.update(field_to_update => true)
      puts "successfully created an invite to cohort #{options[:group_id]} for user #{user_id}"
      
    end
    puts @group_invitation.errors.full_messages
  end



  def process_invites(options)
    emails = process_email_list_for_invite(options[:emails])
    #emails = ENV['EMAILS'].split(',').map {|email| email.strip}

    emails.each do |email|
      #if the user does not exists, invite them into the app. 
      #if the user does exist and they are already in the cohort or already invited to the cohort, skip inviting them.
      if !user = User.find_by(email: email)
        User.invite!({email: email})
      elsif user.cohorts.find_by_id(options[:group_id]) || user.group_invitations.find_by(user_id: user.id, group_id: options[:group_id])
        next
      end
      
      create_invitation(options, email)
    end
  end

  def process_email_list_for_invite(emails)
    emails = emails.split(',').map {|email| email.strip}
  end

end
