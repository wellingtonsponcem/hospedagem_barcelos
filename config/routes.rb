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
  get "rooms/config" => "rooms#config", as: :config_rooms

  # Hóspedes (Guests)
  resources :guests, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]

  # Reservas (Reservations)
  resources :reservations do
    member do
      post :checkin
      get :checkout
    end
  end

  # Banho Avulso (Showers)
  resources :showers, only: [ :index, :create, :update ] do
    member do
      patch :finish
    end
  end

  # Financeiro
  resources :cash_registers, only: [ :index, :create, :update ] do
    collection do
      post :close
    end
  end
  resources :transactions, only: [ :index, :create ]

  # Check-out / Vistoria
  resources :checkouts, only: [ :show, :update ], controller: "checkouts"

  # Relatórios
  get "reports" => "reports#index", as: :reports
end
