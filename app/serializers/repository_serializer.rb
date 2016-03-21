class RepositorySerializer < ActiveModel::Serializer

  attributes :id, :username, :name, :ssh_url, :project_id, :is_setup


  has_one :default_branch do
    object.branches.find_by_name(object.default_branch)
  end

  has_one :current_request do
    request = object.request_logs.find_by_status(1)
    request ? request : {}
  end

  has_one :last_completed_request do
    request = object.request_logs.where(is_complete: 1, status: 0).last
    request ? request : {}
  end

  has_many :branches, key: :all_branches
  has_many :request_logs, key: :all_requests

end
