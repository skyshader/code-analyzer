class RepositorySerializer < ActiveModel::Serializer

  attributes :id, :username, :name, :ssh_url, :project_id, :is_setup

  has_one :default_branch do
    object.branches.find_by_name(object.default_branch)
  end

  has_many :branches
  has_many :request_logs, key: :requests

end
