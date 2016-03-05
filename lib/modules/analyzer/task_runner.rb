module Analyzer
  
  TaskRunnerFailureError = Class.new(StandardError)

  class TaskRunner

    attr_reader :repository, :branch, :files, :analyzer_config

    def initialize(repository:, branch:, files:)
      @repository = repository
      @branch = branch
      @files = files
      @directory = repository.directory
      @analyzer_config = Analyzer::BaseConfig.new
    end

    def run
      @analyzer_config.available_engines.each do ||
    end

  end

end