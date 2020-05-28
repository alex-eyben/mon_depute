Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'laws/:id', to: 'laws#show'
  get 'votes/:id', to: 'votes#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :deputies, only: [:show] do
    collection do
      get :results
    end
    member do
      get :like
    end
  end
end
