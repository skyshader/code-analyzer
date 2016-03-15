class RepositorySerializer < ActiveModel::Serializer

  attributes :id, :username, :name, :ssh_url, :project_id, :is_setup

    has_many :branches
    has_many :request_logs

end
