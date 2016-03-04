Rails.application.routes.draw do
  root 'main#test'
  
  get 'activity/repository/:repo_id/:type', to: 'main#repo_activity', as: :repo_activity
  get 'analyze/repository/:repo_id/:type', to: 'main#repo_analyze', as: :repo_analyze
  get 'process/repository/:repo_id/:type', to: 'main#repo_process', as: :repo_process
  get 'generate/key/:username/:email/:host', to: 'main#key_generate', as: :generate_key
  
  # new paths
  post 'repository/setup', to: 'main#setup', as: :setup_path
  post 'repository/analyze', to: 'main#analyze', as: :analyze_path
  post 'repository/activity', to: 'main#activity', as: :activity_path
end
