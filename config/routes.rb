Rails.application.routes.draw do
  root 'main#index'
  post 'main/processUrl'
  get 'main/repo/:id', to: 'main#repo'
end
