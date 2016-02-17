module Repository
	class Activity

		attr_reader :repo, :type
		
		def initialize repo, type
			@type = type
			@repo = repo
		end

		def generate
			Thread.new do
				if @type == 'full'
	      	full_process
	      elsif @type == 'refresh'
	      	partial_process
	      elsif @type == 'series'
	      	just_process
	      end
      end
      msg = { :success => true, :message => "Please wait while we generate activity for the repository!" }
		end

		# ----------------------------------------------
		# Private methods that are used to process repo
		# ----------------------------------------------
		private
			def full_process
				Repository::Config.setup_repo @repo, @type
				start_processing
				Rails.logger.debug "Done full processing --------------"
			rescue => e
				Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
				raise
			end

			def partial_process
				Repository::Config.setup_repo @repo, @type
				start_processing
				Rails.logger.debug "Done partial processing --------------"
			rescue => e
				Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
				raise
			end

			def just_process
				start_processing
				Rails.logger.debug "Done just processing activity --------------"
			rescue => e
				Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
				raise
			end

			def start_processing
				RepoContributor.store_contributors(@repo, git_stats.authors)
				RepoCommit.store_commits(@repo, git_stats.commits)
			end

			def git_stats
				@stats ||= GitStats::GitData::Repo.new(path: @repo.clone_path + "/" + @repo.current_branch, first_commit_sha: from_commit_sha, last_commit_sha: 'HEAD')
			end

			def from_commit_sha
				from_sha = nil
				last_commit = nil
				ActiveRecord::Base.connection_pool.with_connection do 
					last_commit = RepoCommit.where(supplier_project_repo_id: @repo.id).order(:full_date).first
				end
				from_sha = last_commit.sha if last_commit
			end


			# ----------------------------------------------
			# Extra methods that may be used in future
			# ----------------------------------------------

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