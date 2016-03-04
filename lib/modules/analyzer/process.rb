# Analyzer -> process.rb
#
# This class will be used to do initial processing
# like detecting languages used in repo
# and generating list of files to be processed
# with their respective engines 

module Analyzer
  class Process

    attr_reader :repository, :branch, :directory, :files, :config
  
    def initialize(repository:, branch:)
      @repository = repository
      @branch = branch
      @directory = repository.directory
      @config = Analyzer::BaseConfig.new
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


    # ----------------------------------------------
    # Private methods that are used to ANALYZE repo
    # ----------------------------------------------
    private

    # transfer setup to a thread
    def setup
      Thread.new do
        get_bootstrap_config.set_status('analyze') do
          setup_analyzer
        end
      end
      { success: true, message: "Please wait while we analyze your repository!" }
    end


    # setup pre-requisites for analyzer
    def setup_analyzer
      Dir.chdir(@directory) do
        git.pull(@repository)
        Utility::FileHandler.new(
          repository: @repository,
          directory: @directory,
          branch: @branch,
          base_config: get_analyzer_base_config
        ).list_files.diff_files.save
        @files = FileList.get_file_lists @branch
      end
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