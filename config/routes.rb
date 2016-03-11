Rails.application.routes.draw do
  root 'main#index'
  
  get 'activity/repository/:repo_id/:type', to: 'main#repo_activity', as: :repo_activity
  get 'analyze/repository/:repo_id/:type', to: 'main#repo_analyze', as: :repo_analyze
  get 'process/repository/:repo_id/:type', to: 'main#repo_process', as: :repo_process
  get 'ssh/generate/:username/:email/:host', to: 'main#ssh', as: :generate_key
  
  # new paths
  post 'repository/setup', to: 'main#setup', as: :setup_path
  post 'repository/analyze', to: 'main#analyze', as: :analyze_path
  post 'repository/activity', to: 'main#activity', as: :activity_path
end
