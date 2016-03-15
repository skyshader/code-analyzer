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
      get 'activity/index', to: 'activity#index'

      # resources for analyzer data
      resources :repositories, only: [:show]
      resources :branches, only: [:show]
      resources :file_lists, only: [:show]

      # custom routes for analyzer data
      get 'repositories/all/:project_id', to: 'repositories#all'

    end
  end

end
