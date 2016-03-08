module Analyzer
  
  TaskRunnerFailureError = Class.new(StandardError)

  class TaskRunner

    attr_reader :repository, :branch, :batches, :analyzer_config

    def initialize(repository:, branch:, batches:)
      @repository = repository
      @branch = branch
      @batches = batches
      @directory = repository.directory
      @analyzer_config = Analyzer::BaseConfig.new
      @pool = Utility::Pool.new(2)
    end

    def run
      @batches.keys.each do |language|
        Analyzer::BaseConfig::ENGINES[language.to_sym].each do |e|
          @pool.schedule do
            engine = e.new(
              repository: @repository,
              branch: @branch,
              batches: @batches[language]
            ).run
          end
        end
      end
      @pool.shutdown
    rescue => e
      raise
    ensure
      at_exit { @pool.shutdown }
    end

  end

end