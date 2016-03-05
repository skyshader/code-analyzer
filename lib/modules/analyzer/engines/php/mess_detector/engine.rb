# Analyzer -> Engines -> PHP -> MessDetector -> engine.rb
#
# The engine that will run phpmd on project files

module Analyzer
  module Engines
    module PHP
      module MessDetector

        class Engine

          attr_reader :repository, :branch, :batches, :directory

          def initialize(repository:, branch:, batches:)
            @repository = repository
            @branch = branch
            @batches = batches
            @directory = repository.directory
          end


          def run
            puts ">>>>>>>> Running PHP Mess Detector <<<<<<<<"
            puts @batches.to_s
            puts "------------------------------------------------"
          end

        end

      end
    end
  end
end