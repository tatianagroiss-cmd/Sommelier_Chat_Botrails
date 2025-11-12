Rails.application.routes.draw do
  get 'messages/index'
  get 'messages/create'
  get 'chats/create'
  get 'chats/show'
  get 'moods/index'
  get 'moods/create'
  devise_for :users
  root to: "pages#home"
  resources :menu_items, only: [:show, :index]
  resources :beverages, only: [:show, :index]
  resources :wines, only: [:show, :index]
  resources :order_items
  resources :moods, only: [:index]

  resources :chats, only: [:create, :show] do
    resources :messages, only: [:index, :create]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"




end
