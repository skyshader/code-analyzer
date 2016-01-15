set :stage, :staging

# Default branch is :master
set :branch, "staging"
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/deploy/apps/#{fetch(:full_app_name)}"

server 'analyzertest.venturepact.com', user: 'deploy', roles: %w{web app}, primary: true

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :staging