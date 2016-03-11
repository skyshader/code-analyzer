module Activity
  class Process

    ActivityFailureError = Class.new(StandardError)

    attr_reader :repository, :branch, :directory
    
    # initialize object with defaults and a log to keep track of status
    def initialize(repository:, branch:)
      @repository = repository
      @branch = branch
      @directory = repository.directory
      @action = 'activity'
    end


    def self.run data
      repository = branch = nil
      ActiveRecord::Base.connection_pool.with_connection do
        Repository.transaction do
          repository = Repository.get_repository data
          branch = Branch.setup_branch repository if !repository.nil?
        end
      end

      return {
        success: false, 
        message: "The repository you've requested does not exist!"
      } if repository.nil?
      
      new(
        repository: repository,
        branch: branch
      ).generate
    end


    # --------------------------------------------------
    # Private methods that are used to generate ACTIVITY
    # --------------------------------------------------
    private

    # set status while generating activity
    def generate
      Thread.new do
        get_bootstrap_config.set_status do
          generate_activity
        end
      end
      { success: true, message: "Please wait while we generate activity for the repository!" }
    end

    # configure and start processing the repository
    def generate_activity
      Dir.chdir(@directory) do
        start_processing
      end
    rescue => e
      raise ActivityFailureError, "Failed to generate activity! -> " + e.message
    end


    # store results of activity
    def start_processing
      git.pull(@repository)
      Contributor.store_contributors(branch: @branch, contributors: git_stats.authors)
      Commit.store_commits(branch: @branch, commits: git_stats.commits)
    end


    # generate activity data
    def git_stats
      @stats ||= GitStats::GitData::Repo.new(path: @repository.directory, first_commit_sha: from_commit_sha, last_commit_sha: 'HEAD')
    end


    # get last commit sha since repo was last analyzed
    def from_commit_sha
      from_sha = nil
      last_commit = nil
      ActiveRecord::Base.connection_pool.with_connection do 
        last_commit = Commit.where(branch_id: @branch.id).order(:full_date).first
      end
      from_sha = last_commit.sha if !last_commit.nil?
    end


    # get object of git utility
    def git
      @git ||= Utility::Git.new
    end


    # get object of bootstrap config
    def get_bootstrap_config
      @config ||= Bootstrap::Config.new(
        repository: @repository,
        branch: @branch,
        directory: @directory,
        action: 'activity'
      )
    end
  
  end
end