Rails.application.routes.draw do
  root 'main#index'
  
  # paths to tasks
  post 'ssh/generate', to: 'main#ssh', as: :generate_key
  post 'repository/setup', to: 'main#setup', as: :setup_path
  post 'repository/analyze', to: 'main#analyze', as: :analyze_path
  post 'repository/activity', to: 'main#activity', as: :activity_path

  # paths to api for accessing data
  namespace :api do
    namespace :v1 do
      # routes for activity data
      get 'activity/get_default/:repository_id', to: 'activity#get_default'
      get 'activity/get_by_branch/:name/:repository_id', to: 'activity#get_by_branch'

      # resources for analyzer data
      # resources :branches, only: [:show]
      # resources :file_lists, only: [:show]

      # routes for overview
      get 'overview/get_default/:repository_id', to: 'overview#get_default'
      get 'overview/get_by_branch/:name/:repository_id', to: 'overview#get_by_branch'

      # routes for repositories
      get 'repositories/get/:id', to: 'repositories#get'
      get 'repositories/all_by_project/:project_id', to: 'repositories#all_by_project'

      # routes for branches
      get 'branches/get_default/:repository_id', to: 'branches#get_default'
      get 'branches/get_by_name/:name/:repository_id', to: 'branches#get_by_name'

      # routes for files
      get 'files/get_files_by_default_branch/:repository_id', to: 'files#get_files_by_default_branch'
      get 'files/get_files_by_branch/:name/:repository_id', to: 'files#get_files_by_branch'

    end
  end

end
