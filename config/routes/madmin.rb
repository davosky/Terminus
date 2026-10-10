# Below are the routes for madmin
namespace :madmin do
  resources :transports
  resources :users
  root to: "dashboard#show"
end
