# Analyzer -> setup.rb
#
# This class will be used to do basic setup
# in order to start analysis of the repository 

module Repository
  class Setup


  
    def initialize(params = {})
      ActiveRecord::Base.connection_pool.with_connection do
        # @repo = Repository.create_repository(params)
      end
      # @directory = repo_path
    end


    def do_setup
      Thread.new do
        Repository::Config.get_config.set_setup_status {
          setup_repo
        }
      end
    end


    private

    attr_reader :repo, :directory

    def setup_repo
      Dir.chdir(@directory) do
        Repository::Git.clone @repo
        Repository::Git.pull @repo
        # read directory and generate processable dir structure
      end
    end

    def repo_path
      repo_name = @repo.repo_name.gsub(/[.]+/, '-') || @repo.repo_name
      Rails.root.join('storage', 'repos', @repo.username, @repo.supplier_project_id.to_s, repo_name)
    end

  end
end