Rails.application.routes.draw do
  draw :madmin
  devise_for :users
  root "home#index"

  resources :transports do
    get :confirm_destroy, on: :member
  end

  resources :vehicles do
    get :confirm_destroy, on: :member
  end

  resources :paths do
    get :confirm_destroy, on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
