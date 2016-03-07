# Analyzer -> Engines -> PHP -> CodeSniffer -> engine.rb
#
# The engine that will run phpcs on project files

module Analyzer
  module Engines
    module PHP
      module CodeSniffer

        class Engine

          attr_reader :repository, :branch, :batches, :directory, :engine_config

          def initialize(repository:, branch:, batches:)
            @repository = repository
            @branch = branch
            @batches = batches
            @directory = repository.directory
            @engine_config = ::Analyzer::Engines::PHP::CodeSniffer::Config
          end


          def run
            puts ">>>>>>>> Running PHP Code Sniffer <<<<<<<<"
            puts @engine_config::SNIFFS.keys
            puts @batches.to_s
            puts "------------------------------------------------"
          end

        end

      end
    end
  end
end