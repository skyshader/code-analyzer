# Analyzer -> Engines -> PHP -> CodeSniffer -> engine.rb
#
# The engine that will run phpcs on project files

module Analyzer
  module Engines
    module PHP
      module CodeSniffer

        class Engine

          attr_reader :repository, :branch, :batches, :directory

          def initialize(repository:, branch:, batches:)
            @repository = repository
            @branch = branch
            @batches = batches
            @directory = repository.directory
          end


          def run
            puts ">>>>>>>> Running PHP Code Sniffer <<<<<<<<"
            puts @batches.to_s
            puts "------------------------------------------------"
          end

        end

      end
    end
  end
end