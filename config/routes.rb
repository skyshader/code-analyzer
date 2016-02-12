Rails.application.routes.draw do
  root 'main#test'
  post 'main/process_url'
  get 'activity/repository/:repo_id/:type', to: 'main#repo_activity', as: :repo_activity
  get 'analyze/repository/:repo_id/:type', to: 'main#repo_analyze', as: :repo_analyze
  get 'generate/key/:git_name/:email', to: 'main#process_key', as: :generate_key
  get 'activate/key/:git_name', to: 'main#activate_key', as: :verify_key
end
