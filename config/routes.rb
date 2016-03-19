Rails.application.routes.draw do
  root 'main#index'
  
  # paths to tasks
  get 'ssh/generate/:username/:email/:host', to: 'main#ssh', as: :generate_key
  post 'repository/setup', to: 'main#setup', as: :setup_path
  post 'repository/analyze', to: 'main#analyze', as: :analyze_path
  post 'repository/activity', to: 'main#activity', as: :activity_path

  # paths to api for accessing data
  namespace :api do
    namespace :v1 do
      # routes for activity data
      # get 'activity/index', to: 'activity#index'

      # resources for analyzer data
      # resources :branches, only: [:show]
      # resources :file_lists, only: [:show]

      # routes for repositories
      get 'repositories/get/:id', to: 'repositories#get'
      get 'repositories/all_by_project/:project_id', to: 'repositories#all_by_project'

    end
  end

end
