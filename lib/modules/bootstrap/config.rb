module Bootstrap

  ConfigFailureError = Class.new(StandardError)

  class Config

    attr_reader :repository, :branch, :directory

    # initialize new config with required objects
    def initialize(repository:, branch:, directory:)
      @repository = repository
      @branch = branch
      @directory = directory
    end

    # new method for updating status
    def set_setup_status
      begin
        yield
        ActiveRecord::Base.connection_pool.with_connection do
          @branch.update(:is_setup => 1)
        end
      rescue => e
        Rails.logger.debug "Exception ---------------------" + e.message + " >>> " + e.backtrace.to_s
        ActiveRecord::Base.connection_pool.with_connection do
          @branch.update(:is_setup => 0)
        end
      ensure
        puts "------- Setup repository complete! -------"
        # request_callback('setup')
      end
    end


    # update log status and notify for each step
    def status status
      yield
      ActiveRecord::Base.connection_pool.with_connection do 
        @log.update(success_status: status, is_error: 0,  error_status: nil, error_message: nil)
      end
    rescue => e
      ActiveRecord::Base.connection_pool.with_connection do 
        @log.update(success_status: 0, is_error: 1, error_status: status, error_message: e.to_s)
      end
      Rails.logger.debug "Exception at status " + status.to_s + " : " + e.message + " --- " + e.backtrace.to_s
      raise
    ensure
      # call to request url
      # request_url(repo, status, caller_locations(2,2)[0].label)
    end


    # clone and pull repo setup
    def setup_repo
      status(2) {
        setup_path
        if @type == 'full'
          Repository::Git.clone(@repo, @type)
        end
        Repository::Git.pull(@repo, @type)
      }
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


    def request_callback process
      uri = URI.parse(Rails.configuration.x.notify_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)

      if process === 'setup'
        request.set_form_data({
          "Process[project_id]" => @repository.project_id,
          "Process[repository]" => @repository.ssh_url,
          "Process[type]" => process,
          "Process[status]" => @branch.is_setup
        })
      elsif process === 'analyzer'
        # some code
      elsif process === 'activity'
        # some code
      end
      
      response = http.request(request)
      puts response.body.to_s
    rescue => e
      puts e.message
    end
  
  end
end