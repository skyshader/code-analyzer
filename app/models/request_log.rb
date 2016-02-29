class RequestLog < ActiveRecord::Base
	
	belongs_to :branch

	def self.create_log repo, process, type
		ActiveRecord::Base.connection_pool.with_connection do 
			type = 'full' if type == 'series'
			@log = RepoLog.create(
				:process_type => process,
				:request_type => type,
				:supplier_project_repo_id => repo.id
			)
		end
		@log
	end

end
