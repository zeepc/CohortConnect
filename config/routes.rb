Rails.application.routes.draw do
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { invitations: 'invitations', omniauth_callbacks: 'users/omniauth_callbacks' }
  
  post '/invites', to: 'group_invitations#invites'
  delete '/cohorts/remove_user_from_cohort', to: 'cohorts#remove_from_cohort'
  put '/cohorts/add_user_to_admin', to: 'cohorts#add_user_to_admin'
  get '/cohorts/:id/pending_requests', to: 'cohorts#pending_requests'
  get '/users/profile', to: 'users#profile'
  delete '/users/profile', to: 'users#destroy'

  resources :cohorts


  resources :users, only: []

  resources :group_invitations, only: [:create, :destroy]

  root to: 'users#login'
end
