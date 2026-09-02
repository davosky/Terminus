Rails.application.routes.draw do
  devise_for :users

  resources :vehicles do
    member do
      get :confirm_destroy
    end
  end

  resources :transports do
    member do
      get :confirm_destroy
    end
  end

  resources :reasons do
    member do
      get :confirm_destroy
    end
  end

  resources :paths do
    member do
      get :confirm_destroy
    end
  end

  resources :places do
    member do
      get :confirm_destroy
    end
  end

  resources :structures do
    member do
      get :confirm_destroy
    end
  end

  resources :mission_requests do
    member do
      get :confirm_destroy
    end
  end

  resources :reimbursements do
    member do
      get :confirm_destroy
    end
  end

  namespace :validator do
    resources :mission_requests, only: [ :index ] do
      collection { get :approved }
      member do
        patch :approve
        patch :reject
      end
    end
  end

  namespace :director do
    resources :mission_requests, only: [ :index, :show ]
  end

  get  "validazione_missione/:token/approva",  to: "mission_request_validations#approve_form", as: :approve_form_mission_request_validation
  post "validazione_missione/:token/approva",  to: "mission_request_validations#approve",      as: :approve_mission_request_validation
  get  "validazione_missione/:token/respingi", to: "mission_request_validations#reject_form",  as: :reject_form_mission_request_validation
  post "validazione_missione/:token/respingi", to: "mission_request_validations#reject",        as: :reject_mission_request_validation

  namespace :admin do
    resources :users do
      member do
        get :download_signature
        get :download_validator_signature
        get :download_confirmator_signature
      end
    end
    resources :vehicles
    resources :transports
    resources :reasons
    resources :paths
    resources :places
    resources :structures
    resources :mission_requests
    resources :reimbursements
    root to: "users#index"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
