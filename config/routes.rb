Rails.application.routes.draw do
  get 'pages/index'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

  authenticated :user do
    root 'albums#index', as: :authenticated_root
  end

  get 'connect', to: 'users#connect'
  get 'settings', to: 'devise/registrations#edit'
  get '/signout' => 'sessions#destroy', :as => :signout

  resources :artists do
    member do
      get 'unfollow'
      get 'follow'
    end
    collection do
      get 'search'
    end
  end

  resources :charts do
    collection do
      get 'artists'
      get 'albums'
    end
  end

  resources :users

  resources :albums
  root "pages#index"
end
