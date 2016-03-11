module Bootstrap

  ConfigFailureError = Class.new(StandardError)

  class Config

    attr_reader :repository, :branch, :directory, :action, :request

    # initialize new config with required objects
    def initialize(repository:, branch:, directory:, action:)
      puts "Initialized config bootstrap ==--==-=-"
      @repository = repository
      @branch = branch
      @directory = directory
      @action = action
      @request = RequestLog.current_log(
        repository: repository,
        branch: branch,
        action: action
      )
    end

    # new method for updating status
    def set_status
      begin
        set_before_status
        yield
        set_success_status
      rescue => e
        Rails.logger.debug "Exception ---------------------" + e.message + " >>> " + e.backtrace.to_s
        set_failure_status
      ensure
        puts "------- #{@action} repository complete! -------"
        @request.update(status: 0)
        # request_callback
        initiate_next_queued_process
      end
    end


    # for initial path setup create directories as needed
    def path_setup
      FileUtils.mkdir_p(@directory) unless File.directory?(@directory)
      ActiveRecord::Base.connection_pool.with_connection do
        @repository.update(directory: @directory)
      end
    rescue => e
      raise ConfigFailureError, "Failed to setup initial path " + e.message
    end


    def set_before_status
      ActiveRecord::Base.connection_pool.with_connection do
        @repository.update(is_setup: 0) if @action === 'setup'
        @request.update(is_waiting: 0, is_active: 1) if @action === 'activity'
        @request.update(is_waiting: 0, is_active: 1) if @action === 'analyze'
      end
    end


    def set_success_status
      ActiveRecord::Base.connection_pool.with_connection do
        if @action === 'setup'
          @repository.update(is_setup: 1)
        elsif @action === 'activity'
          @request.update(is_active: 0, is_complete: 1)
        elsif @action === 'analyze'
          @request.update(is_active: 0, is_complete: 1)
        end
      end
    end


    def set_failure_status
      ActiveRecord::Base.connection_pool.with_connection do
        if @action === 'setup'
          @repository.update(is_setup: 0)
        elsif @action === 'activity'
          @request.update(is_active: 0, is_error: 1, error_message: e.message, error_trace: e.backtrace.to_s)
        elsif @action === 'analyze'
          @request.update(is_active: 0, is_error: 1, error_message: e.message, error_trace: e.backtrace.to_s)
        end
      end
    end


    def initiate_next_queued_process
      request = RequestLog.next_queued_request
      if request
        Rails.logger.debug "Processing next request : " + request.inspect
        Analyzer::Process.new(
          repository: request.repository,
          branch: request.branch
        ).setup if request.request_type === 'analyze'
        Activity.Process.new(
          repository: repository,
          branch: branch
        ).generate if request.request_type === 'activity'
      end
    end


    # request back with status
    def request_callback
      uri = URI.parse(Rails.configuration.x.notify_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)

      if @action === 'setup'
        request.set_form_data({
          "Process[project_id]" => @repository.project_id,
          "Process[repository]" => @repository.ssh_url,
          "Process[type]" => @action,
          "Process[status]" => @repository.is_setup
        })
      elsif @action === 'analyze'
        # some code
      elsif @action === 'activity'
        request.set_form_data({
          "Process[project_id]" => @repository.project_id,
          "Process[repository]" => @repository.ssh_url,
          "Process[type]" => @action,
          "Process[status]" => @branch.is_activity_generated
        })
      end

      response = http.request(request)
      puts response.body.to_s
    rescue => e
      puts e.message
    end

  end
end