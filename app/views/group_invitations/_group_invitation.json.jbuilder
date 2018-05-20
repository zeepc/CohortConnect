json.extract! group_invitation, :id, :sent_by_id, :user_id, :group_id, :accepted?, :admin_approved?, :created_at, :updated_at
json.url group_invitation_url(group_invitation, format: :json)
