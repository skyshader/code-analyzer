Rails.application.routes.draw do
  root 'main#index'
  post 'main/process_url'
  get 'main/repo/:repo_id/:analysis_type', to: 'main#repo'
end
