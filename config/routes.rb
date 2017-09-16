Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'api/users/sessions'
    }

    resources :users, only: [:index, :show]
  end
end
