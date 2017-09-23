Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'api/users/sessions',
      registrations: 'api/users/registrations'
    }

    resources :users, only: [:index, :show] do
      get 'search_email', on: :collection
      post 'invite_to_chat'
    end

    resources :regions, only: [:index, :show]
    resources :cities, only: [:index, :show]
    resources :categories, only: [:index, :show]
    resources :questions, only: [:index, :show, :create]
    resources :chats, only: [:show, :create]
    resources :chat_messages, only: [:create]

    get :get_token, to: 'guests#get_token'

    mount ActionCable.server => "/cable"
  end
end
