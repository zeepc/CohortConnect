class GroupInvitation < ApplicationRecord
  belongs_to :user

  after_save :check_for_acceptance



  private
  #checks to see if the invitation was accepted and admin approved.
  #if it is, then create a link between user and specified cohort and delete the completed invitation.
  # otherwise do nothing.
  def check_for_acceptance
    if self.accepted? && self.admin_approved?
      group_id =  self.group_id
      user_id = self.user_id
      new_association = CohortUser.create(cohort_id: group_id, user_id: user_id)

      if new_association.persisted?
        self.destroy
      end
    end
  end
  
end
