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
    def set_status process
      begin
        yield
        ActiveRecord::Base.connection_pool.with_connection do
          if process === 'setup'
            @repository.update(is_setup: 1)
          elsif process === 'activity'
            @branch.update(is_activity_generated: 1)
          end
        end
      rescue => e
        Rails.logger.debug "Exception ---------------------" + e.message + " >>> " + e.backtrace.to_s
        ActiveRecord::Base.connection_pool.with_connection do
          if process === 'setup'
            @repository.update(is_setup: 0)
          elsif process === 'activity'
            @branch.update(is_activity_generated: 0)
          end
        end
      ensure
        puts "------- #{process} repository complete! -------"
        # request_callback(process)
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


    # request back with status
    def request_callback process
      uri = URI.parse(Rails.configuration.x.notify_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)

      if process === 'setup'
        request.set_form_data({
          "Process[project_id]" => @repository.project_id,
          "Process[repository]" => @repository.ssh_url,
          "Process[type]" => process,
          "Process[status]" => @repository.is_setup
        })
      elsif process === 'analyzer'
        # some code
      elsif process === 'activity'
        request.set_form_data({
          "Process[project_id]" => @repository.project_id,
          "Process[repository]" => @repository.ssh_url,
          "Process[type]" => process,
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