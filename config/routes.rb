Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'laws/:id', to: 'laws#show'
  get 'votes/:id', to: 'votes#show'
  get '/dashboard', to: 'pages#dashboard'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :deputies, only: [:show] do
    collection do
      get :results
    end
    member do
      get :like
      get :follow
    end
  end
end
