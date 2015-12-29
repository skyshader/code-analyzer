Rails.application.routes.draw do
  root 'main#index'
  post 'main/process_url'
  get 'main/repo/:repo_id/:analysis_type', to: 'main#repo'
  get 'generate/key/:email/:uid', to: 'main#process_key'
end
