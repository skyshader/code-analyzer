# Config -> setup.rb
#
# This class will be used to do basic setup
# in order to start analysis of the repository 

module Bootstrap
  
  SetupFailureError = Class.new(StandardError)
  
  class Setup

    def initialize(repository:, branch:)
      @repository = repository
      @branch = branch
      @directory = repo_path
    end


    def configure
      Thread.new do
        get_bootstrap_config.set_setup_status {
          Rails.logger.debug "Initializing setup---------------------"
          setup_repository
          Rails.logger.debug "Completed setup------------------------"
        }
      end
    end


    private

    attr_reader :repository, :branch, :directory


    def setup_repository
      get_bootstrap_config.path_setup
      Dir.chdir(@directory) do
        # git.empty().clone(@repository).pull(@repository)
        Rails.logger.debug "Cloned and pull repository ---------------------"
        Utility::FileHandler.new(
          repository: @repository,
          directory: @directory,
          branch: @branch,
          base_config: get_analyzer_base_config
        ).list_files.diff_files.save
        Rails.logger.debug "Done processing repository files ---------------------"
      end
    end


    def repo_path
      repo_name = @repository.name.gsub(/[.]+/, '-') || @repository.name
      Rails.root.join('storage', 'repos', @repository.username, @repository.project_id.to_s, repo_name)
    end


    ##----------  Generate objects of other needed class  ----------##
    
    # get object of bootstrap config
    def get_bootstrap_config
      @config ||= Bootstrap::Config.new(
        repository: @repository,
        branch: @branch,
        directory: @directory
      )
    end


    # get analyzer config
    def get_analyzer_base_config
      @analyzer_config ||= Analyzer::BaseConfig.new
    end


    # get object of git utility
    def git
      @git ||= Utility::Git.new
    end

  end
end