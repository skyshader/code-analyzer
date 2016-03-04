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
        get_bootstrap_config.set_status('setup') do
          setup_repository
        end
      end
      { :success => true, :message => "Please wait while we setup your repository!" }
    end


    private

    attr_reader :repository, :branch, :directory


    def setup_repository
      get_bootstrap_config.path_setup
      Dir.chdir(@directory) do
        git.empty().clone(@repository).pull(@repository)
        Utility::FileHandler.new(
          repository: @repository,
          directory: @directory,
          branch: @branch,
          base_config: get_analyzer_base_config
        ).list_files.diff_files.save
      end
    rescue => e
      raise SetupFailureError, "Failed to setup the repository! -> " + e.message
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