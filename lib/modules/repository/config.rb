module Repository
	class Config

		def self.status(repo, status, type)
		  yield
		  ActiveRecord::Base.connection_pool.with_connection do 
		    repo.update(analysis_status: status, error_status: nil, error_message: nil)
		  end
		rescue => e
		  ActiveRecord::Base.connection_pool.with_connection do 
		    repo.update(analysis_status: 0, error_status: status, error_message: e.to_s)
		  end
		  Rails.logger.debug "Exception at status " + status.to_s + " : " + e.message + " --- " + e.backtrace.to_s
		  raise
		ensure
		  # call to request url
		  # request_url(repo, status, caller_locations(2,2)[0].label)
		end

		def self.setup_path repo
			if !repo.clone_path.nil? and !repo.clone_path.empty?
				Dir.chdir(repo.clone_path)
			else
				self.initial_path_setup repo
			end
		end

		def self.initial_path_setup repo
		  repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
		  repo_path = Rails.root.join('storage', 'repos', repo.username, repo.supplier_project_id.to_s, repo_name)
		  FileUtils.mkdir_p(repo_path) unless File.directory?(repo_path)
		  Dir.chdir(repo_path)
		  ActiveRecord::Base.connection_pool.with_connection do 
		    repo.update(clone_path: repo_path)
		  end
		end
	
	end
end