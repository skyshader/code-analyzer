# Analyzer -> Engines -> PHP -> MessDetector -> engine.rb
#
# The engine that will run phpmd on project files

module Analyzer
  module Engines
    module PHP
      module MessDetector

        class Engine

          attr_reader :repository, :branch, :batches, :directory, :engine_config

          def initialize(repository:, branch:, batches:)
            @repository = repository
            @branch = branch
            @batches = batches
            @directory = repository.directory
            @engine_config = ::Analyzer::Engines::PHP::MessDetector::Config
          end


          def run
            puts ">>>>>>>> Running PHP Mess Detector <<<<<<<<"
            puts @engine_config::CATEGORIES.keys
            puts @batches.to_s
            puts "------------------------------------------------"
          end

        end

      end
    end
  end
end