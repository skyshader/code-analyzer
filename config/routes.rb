Rails.application.routes.draw do
  root 'main#test'
  get 'activity/repository/:repo_id/:type', to: 'main#repo_activity', as: :repo_activity
  get 'analyze/repository/:repo_id/:type', to: 'main#repo_analyze', as: :repo_analyze
  get 'generate/key/:username/:email/:host', to: 'main#key_generate', as: :generate_key
end
