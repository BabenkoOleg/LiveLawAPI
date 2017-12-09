Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'api/users/sessions',
      registrations: 'api/users/registrations'
    }

    resources :users, only: [:index, :show] do
      get 'search_email', on: :collection
      post 'invite_to_chat'
      post 'upload_avatar'
    end

    resources :regions, only: [:index, :show]
    resources :cities, only: [:index, :show]
    resources :categories, only: [:index, :show]
    resources :questions, only: [:index, :show, :create]
    resources :chats, only: [:create] do
      get 'active', on: :collection
      post 'reject', on: :collection
    end
    resources :chat_messages, only: [:create]
    resources :conversations, only: [:index, :show] do
      post ':id', to: 'conversations#create', on: :collection
      post ':id/read', to: 'conversations#read', on: :collection
    end

    get :get_token, to: 'guests#get_token'

    get 'legal_library', to: 'legal_library#index'
    get 'legal_library/categories/:id', to: 'legal_library#categories'
    get 'legal_library/documents/:id', to: 'legal_library#documents'

    mount ActionCable.server => "/cable"
  end
end
