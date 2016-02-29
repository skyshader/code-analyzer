module Repository
  class Config

    attr_reader :repo, :log, :process, :type

    # initialize new config with required objects
    def initialize repo, log, process, type
      @repo, @log, @process, @type = repo, log, process, type
    end


    # transfer request to object for setting up repo
    def self.setup_repo repo, log, process, type
      new(repo, log, process, type).setup_repo
    end

    # new method for updating status
    def set_status status
      begin
        yield
        # more code
      rescue => e
        # handle exception
      ensure
        # respond back with status
        # Config.new(repository).request_url
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
    

    # basic path setup for repository
    def setup_path
      if !@repo.clone_path.nil? and !@repo.clone_path.empty?
        Dir.chdir(@repo.clone_path)
      else
        initial_path_setup
      end
    end


    # for initial path setup create directories as needed
    def initial_path_setup
      repo_name = @repo.repo_name.gsub(/[.]+/, '-') || @repo.repo_name
      repo_path = Rails.root.join('storage', 'repos', @repo.username, @repo.supplier_project_id.to_s, repo_name)
      FileUtils.mkdir_p(repo_path) unless File.directory?(repo_path)
      Dir.chdir(repo_path)
      ActiveRecord::Base.connection_pool.with_connection do 
        @repo.update(clone_path: repo_path)
      end
    end

    def request_url
      uri = URI.parse(Rails.configuration.x.notify_url)
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({"Analyzer[repo_id]" => repo.id, "Analyzer[status]" => status, "Analyzer[type]" => call_type})
      response = http.request(request)
      puts response.body.to_s
    rescue => e
      puts e.message
    end
  
  end
end