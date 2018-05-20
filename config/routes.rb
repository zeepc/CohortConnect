Rails.application.routes.draw do
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { invitations: 'invitations', omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :cohorts do
    resources :group_invitations
  end
  
  resources :users
  resources :group_invitations
  

  root to: 'cohorts#index'
end
