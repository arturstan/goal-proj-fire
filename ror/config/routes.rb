Rails.application.routes.draw do
  resources :task_comments
  resources :tasks
  resources :project_comments
  resources :goal_comments
  resources :projects
  resources :goals
  resources :tags
  resources :areas
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/api/alive" => "alive#alive"

  post "areas/:id/up" => "areas#up"
  post "areas/:id/down" => "areas#down"

  post "goals/:id/up" => "goals#up"
  post "goals/:id/down" => "goals#down"
  post "goals/:id/delete_with_projects" => "goals#delete_with_projects"

  post "projects/:id/up" => "projects#up"
  post "projects/:id/down" => "projects#down"
  post "projects/:id/exchange_hierarchy" => "projects#exchange_hierarchy"

  post "tasks/:id/up" => "tasks#up"
  post "tasks/:id/down" => "tasks#down"

  root to: "home#index"
end
