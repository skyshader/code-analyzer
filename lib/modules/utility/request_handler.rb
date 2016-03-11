module Utility

  RequestHandlerFailureError = Class.new(StandardError)

  class RequestHandler

    def initialize(repository:, branch:, action:, force:)
      @repository = repository
      @branch = branch
      @action = action
      @force = false
      @force = force if Rails.env.development?
    end


    def self.run(action, data)
      repository = branch = nil
      ActiveRecord::Base.connection_pool.with_connection do
        Repository.transaction do
          repository = Repository.get_repository data
          branch = Branch.setup_branch repository if !repository.nil?
        end
      end

      return false if repository.nil?
      
      new(
        repository: repository,
        branch: branch,
        action: action,
        force: data[:force] || false
      ).handle_request
    end


    def handle_request
      if RequestLog.is_currently_idle? || @force
        RequestLog.log_request(
          repository: @repository,
          branch: @branch,
          action: @action,
          force: @force
        )
        return {
          success: true,
          status: 1,
          message: "Please wait while we process your request."
        }
      else
        RequestLog.queue_request(
          repository: @repository,
          branch: @branch,
          action: @action
        )
        return {
          success: true,
          status: 2,
          message: "Your request will be processed shortly."
        }
      end
    end

  end

end