Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'
  get '/sitemap', to: 'sitemaps#index', :defaults => {:format => 'xml'}
  # get 'laws/:id', to: 'laws#show'
  resources :laws, only: [:show, :new, :create]
  get 'votes/:id', to: 'votes#show'
  get '/dashboard', to: 'pages#dashboard'
  get '/get_followed_deputies', to: 'deputies#get_followed_deputies'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :deputies, only: [:show] do
    collection do
      get :results
    end
    member do
      get :like
      get :like_guest
      post :follow
      get :follow_guest
      get :is_followed
    end
  end

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
