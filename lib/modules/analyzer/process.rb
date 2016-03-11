# Analyzer -> process.rb
#
# This class will be used to do initial processing
# like detecting languages used in repo
# and generating list of files to be processed
# with their respective engines

module Analyzer
  class Process

    attr_reader :repository, :branch, :directory, :batches

    def initialize(repository:, branch:)
      @repository = repository
      @branch = branch
      @directory = repository.directory
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
      ).setup
    end


    # transfer setup to a thread
    def setup
      Thread.new do
        get_bootstrap_config.set_status('analyze') do
          run_analyzer
        end
      end
      { success: true, message: "Please wait while we analyze your repository!" }
    end


    # ----------------------------------------------
    # Private methods that are used to ANALYZE repo
    # ----------------------------------------------
    private


    # setup pre-requisites for analyzer
    def run_analyzer
      Dir.chdir(@directory) do
        # freshen up the repository
        # git.pull(@repository)

        # update file listing
        Utility::FileHandler.new(
          repository: @repository,
          branch: @branch
        ).list_files.diff_files.save

        # get grouped files by extensions
        @batches = Utility::FileHandler.new(
          repository: @repository,
          branch: @branch
        ).grouped_file_batches

        # run tasks
        Analyzer::TaskRunner.new(
          repository: @repository,
          branch: @branch,
          batches: @batches
        ).run

        # generate stats
        Stats::ProcessStats.new(
          branch: @branch
        ).run

        # update version
        Branch.update_version @branch
      end
    rescue => e
      Branch.reset_version @branch
      raise
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
        directory: @directory
      )
    end

  end
end