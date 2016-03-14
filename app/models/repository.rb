class Repository < ActiveRecord::Base

  has_many :branches
	has_many :request_logs


  # create a new repository
  def self.create_repository repository
    Repository.find_or_create_by(
      ssh_url: repository[:ssh_url],
      project_id: repository[:project_id]
    ) do |r|
      r.username = repository[:username]
      r.owner = repository[:owner]
      r.name = repository[:name]
      r.ssh_url = repository[:ssh_url]
      r.default_branch = repository[:default_branch]
      r.current_branch = repository[:current_branch]
      r.is_private = repository[:is_private]
    end
  end


  # return the repository and update current branch
  def self.get_repository data
    repository = Repository.where(
      :project_id => data[:project_id],
      :ssh_url => data[:ssh_url],
      :is_setup => 1
    ).first

    repository.update(
      :current_branch => data[:analyze_branch]
    ) if !repository.nil?
    repository
  end


end
