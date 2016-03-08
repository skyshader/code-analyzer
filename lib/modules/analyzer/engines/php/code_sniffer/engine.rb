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
            @engine_formatter = ::Analyzer::Engines::PHP::CodeSniffer::Formatter
          end

          def run
            Rails.logger.debug ">>>>>>>> Running PHP Code Sniffer <<<<<<<<"
            @batches.each do |batch|
              result_xml = process_batch batch
              result_hash = @engine_formatter.format result_xml, @branch
              CodeIssue.store_results result_hash, @branch
            end
            rescue => e
              Rails.logger.debug "Exception ---------------------" + e.message + " >>> " + e.backtrace.to_s
            raise
          end

          private
          def process_batch batch
            files = nil
            batch.each do |file|
              files = '' if !files
              files += file[:full_path] + " "
            end
            files.chomp!(' ')
            result = execute_phpcs_command(files)
          end


          def execute_phpcs_command files
            `phpcs --report=checkstyle #{files}`
          end
        end
      end
    end
  end
end