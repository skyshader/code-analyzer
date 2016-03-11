class RequestLog < ActiveRecord::Base
  
  belongs_to :branch
  belongs_to :repository

  def self.is_currently_idle?
    RequestLog.where(
      is_active: 1,
      status: 1
    ).first.nil?
  end


  def self.queue_request(repository:, branch:, action:)
    unless is_active_request?(repository, branch, action)
      RequestLog.create({
        request_type: action,
        is_waiting: 1,
        branch_id: branch.id,
        repository_id: repository.id
      })
    end
  end


  def self.log_request(repository:, branch:, action:, force:)
    discard_active_requests if force
    RequestLog.create({
      request_type: action,
      is_active: 1,
      branch_id: branch.id,
      repository_id: repository.id
    })
  end


  def self.discard_active_requests
    RequestLog.where(is_active: 1).update_all(is_active: 0, status: 0) if force
  end


  def self.is_active_request?(repository, branch, action)
    RequestLog.where(
      request_type: action,
      is_active: 1,
      branch_id: branch.id,
      repository_id: repository.id
    ).exists?
  end


  def self.current_log(repository:, branch:, action:)
    RequestLog.where(
      repository_id: repository.id,
      branch_id: branch.id,
      is_active: 1,
      request_type: action,
      status: 1
    ).last
  end


  def self.next_queued_request
    request = RequestLog.where(is_waiting: 1, status: 1).first
    request.update(is_waiting: 0, is_active: 1)
    request
  end

end
