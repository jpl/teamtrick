Teamtrick::Application.routes.draw do
  resources :user_sessions
  root :to => "projects#index" # optional, this just sets the root route
  match 'message' => 'message#index', :as => :message
  match 'my_profile' => 'users#my_profile', :as => :my_profile
  resources :projects do
      resources :sprints do
          match 'day/:day' => 'sprints#day', :as => :day
      match 'day/' => 'sprints#day', :as => :empty_day
    end

    resources :duties
    resources :stories
    resources :tasks
  end

  match '/projects/:id/stats_for_date/:date' => 'projects#stats_for_date', :as => :project_stats_for_date
  resources :sprints
  resources :commitments
  resources :users
  resources :duties
  match 'projects/:project_id/sprints/:id/planning' => 'sprints#update', :as => :update_project_sprint_planning, :mode => 'planning', :via => :put
  match 'projects/:project_id/sprints/:id/current' => 'sprints#show_current', :as => :project_sprint_current, :mode => 'current', :via => :get
  match 'projects/:project_id/sprints/:id/planning' => 'sprints#show_planning', :as => :project_sprint_planning, :mode => 'planning', :via => :get
  match 'projects/:project_id/sprints/:id/closed' => 'sprints#show_closed', :as => :project_sprint_closed, :mode => 'closed', :via => :get
  match 'projects/:project_id/sprints/:id/planning/edit' => 'sprints#edit', :as => :edit_project_sprint_planning, :mode => 'planning'
  match 'projects/:project_id/sprints/:id/finish_planning' => 'sprints#finish_planning', :as => :finish_planning_project_sprint, :via => :post
  match '/:controller(/:action(/:id))'
end