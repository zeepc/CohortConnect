json.extract! user, :id, :first_name, :last_name, :profile_image_url, :profile_link_url, :current_employer, :current_title, :city, :state, :created_at, :updated_at
json.url user_url(user, format: :json)
