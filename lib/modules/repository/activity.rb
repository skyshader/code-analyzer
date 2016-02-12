module Repository
	class Activity

		attr_reader :repo, :type
		
		def initialize id, type
			@type = type
			ActiveRecord::Base.connection_pool.with_connection do 
			  @repo = SupplierProjectRepo.find(id)
			end
		end

		def generate
			Thread.new do
				if @type == 'full'
	      	full_process @repo
	      else
	      	partial_process @repo
	      end
      end
		end

		# private methods
		private
			def full_process repo
				Repository::Config.setup_path repo
				Repository::Git.clone(repo, 2, @type)
				start_processing repo
				Rails.logger.debug 'Done processing-----------------'
			rescue => e
				Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
			end

			def partial_process repo
				Repository::Config.setup_path repo
				Repository::Git.pull(repo, 2, @type)
				start_processing repo
			rescue => e
				Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
			end

			def start_processing repo
				last_commit = RepoCommit.where(supplier_project_repo_id: repo.id).order(:full_date).first
				from_sha = nil
				from_sha = last_commit.sha if last_commit
				stats = GitStats::GitData::Repo.new(path: repo.clone_path + "/" + repo.current_branch, first_commit_sha: from_sha, last_commit_sha: 'HEAD')
				RepoContributor.store_contributors(repo, stats.authors)
				RepoCommit.store_commits(repo, stats.commits)
			end

			def day_stat stats
				commits = stats.commits
				data_per_day = commits.inject({}) do |h, commit|
				  dt = commit.date.utc.to_date.to_s
				  if h.key?(dt)
				    h[dt]['additions'] += commit.short_stat.insertions
				    h[dt]['deletions'] += commit.short_stat.deletions
				    h[dt]['files_changed'] += commit.short_stat.files_changed
				    h[dt]['commits'] += 1
				  else
				    h[dt] = {}
				    h[dt]['additions'] = commit.short_stat.insertions
				    h[dt]['deletions'] = commit.short_stat.deletions
				    h[dt]['files_changed'] = commit.short_stat.files_changed
				    h[dt]['commits'] = 1
				  end
				  h
				end
			end
	
	end
end