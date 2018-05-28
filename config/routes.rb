Rails.application.routes.draw do
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { invitations: 'invitations', omniauth_callbacks: 'users/omniauth_callbacks' }
  
  post '/invites', to: 'group_invitations#invites'
  delete '/cohorts/:cohort_id/user/:user_id/remove_user_from_cohort', to: 'cohorts#remove_user_from_cohort'
  put '/cohorts/:cohort_id/user/:user_id/add_user_to_admin', to: 'cohorts#add_user_to_admin'
  get '/users/profile', to: 'users#profile'
  delete '/users/profile', to: 'users#destroy'
  delete '/group_invitations', to: 'group_invitations#destroy'

  resources :cohorts, only: [:create, :show, :destroy, :update]
  resources :group_invitations, only: [:create]

  root to: 'users#login'
end
