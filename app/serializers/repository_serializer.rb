class RepositorySerializer < ActiveModel::Serializer

  attributes :id, :username, :name, :ssh_url, :project_id, :is_setup, :branches
  
end
