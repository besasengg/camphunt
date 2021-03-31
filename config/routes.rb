Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users do
    get "trips/upcoming", to: "trips#upcoming", as: "upcoming_trips"
    get "trips/favorites", to: "trips#favorites", as: "favorite_trips"
    resources :trips, only: [:index, :show]
  end

  resources :trips, except: [:index, :show]
  put "trips/:id/update_favorite_status", to: "trips#update_favorite_status", as: "update_favorite"

  resources :supplies

  put "trip_supplies/:id/increase", to: "trip_supplies#increase", as: "trip_supplies_increase"
  put "trip_supplies/:id/decrease", to: "trip_supplies#decrease", as: "trip_supplies_decrease"

  post "trips/results"
  
  authenticated :user do
    root 'users#show', :as => :authenticated_root
  end
  root 'landing#index'
end
