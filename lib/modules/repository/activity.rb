module Repository
	class Activity

		attr_reader :repo, :log, :process, :type
		
		# initialize object with defaults and a log to keep track of status
		def initialize repo, type
			@repo, @process, @type = repo, 'activity', type
			@log = RepoLog.create_log @repo, @process, @type
		end


		# only activity needs to be generated
		def generate
			Thread.new do
	      process_repo
      end
      msg = { :success => true, :message => "Please wait while we generate activity for the repository!" }
		end


		# needs to generate activity and analysis in series
		def process
			@type = 'full'
			process_repo
		end


		# ----------------------------------------------
		# Private methods that are used to process repo
		# ----------------------------------------------
		private

			# configure and start processing the repository
			def process_repo
				Repository::Config.setup_repo @repo, @log, @process, @type
				start_processing
				Rails.logger.debug "Done full processing --------------"
			rescue => e
				Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
				raise
			end


			# store results of activity
			def start_processing
				Repository::Config.new(@repo, @log, @process, @type).status(3) {
					RepoContributor.store_contributors(@repo, git_stats.authors)
					RepoCommit.store_commits(@repo, git_stats.commits)
				}
			end


			# generate activity data
			def git_stats
				@stats ||= GitStats::GitData::Repo.new(path: @repo.clone_path + "/" + @repo.current_branch, first_commit_sha: from_commit_sha, last_commit_sha: 'HEAD')
			end


			# get last commit sha since repo was last analyzed
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