Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'api/users/sessions'
    }

    resources :users, only: [:index, :show] do
      get 'search_email', on: :collection
    end

    resources :cities, only: [:index, :show]
  end
end
