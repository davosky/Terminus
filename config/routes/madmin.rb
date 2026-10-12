# Below are the routes for madmin
namespace :madmin do
  resources :paths
  resources :places
  resources :reasons
  resources :structures
  resources :transports
  resources :users
  resources :vehicles
  root to: "dashboard#show"
end
