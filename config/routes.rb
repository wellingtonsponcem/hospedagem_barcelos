Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Auth
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy", as: :logout

  # Dashboard
  root "dashboard#index"
  get "dashboard" => "dashboard#index", as: :dashboard

  # Quartos (Rooms)
  resources :rooms, only: [ :index, :create, :update, :destroy ]
end
