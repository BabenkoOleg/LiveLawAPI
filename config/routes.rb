Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'api/users/sessions'
    }

    resources :users, only: [:index, :show] do
      get 'search_email', on: :collection
    end

    resources :regions, only: [:index, :show]
    resources :cities, only: [:index, :show]
    resources :categories, only: [:index, :show]
    resources :questions, only: [:index, :show, :create]
    resources :chats, only: [:show ,:create]

    get :get_token, to: 'guests#get_token'

    mount ActionCable.server => "/cable"
  end
end
