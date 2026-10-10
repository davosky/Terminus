# Below are the routes for madmin
namespace :madmin do
  resources :users
  root to: "dashboard#show"
end
