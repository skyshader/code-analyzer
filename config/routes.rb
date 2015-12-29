Rails.application.routes.draw do
  root 'main#index'
  post 'main/process_url'
  get 'main/repo/:repo_id/:analysis_type', to: 'main#repo', as: :analyze_repo
  get 'generate/key/:git_name/:email', to: 'main#process_key', as: :generate_key
end
