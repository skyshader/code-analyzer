# Analyzer -> Engines -> CSS -> engine.rb
#
# The engine that will run csslint on project files

module Analyzer
  module Engines
    module CSS

      class Engine

        attr_reader :repository, :branch, :batches, :directory, :engine_config

          def initialize(repository:, branch:, batches:)
            @repository = repository
            @branch = branch
            @batches = batches
            @directory = repository.directory
            @engine_config = ::Analyzer::Engines::CSS::Config
            @engine_formatter = ::Analyzer::Engines::CSS::Formatter
          end

          def run
            Rails.logger.debug ">>>>>>>> Running CSS-Lint <<<<<<<<"
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
              files += file[:full_path] + " " if !(file[:full_path].end_with? ".min.css")
            end
            files.chomp!(' ')
            result = execute_phpcs_command(files)
          end


          def execute_phpcs_command files
            `csslint #{@engine_config::RESULT_CONFIG} #{files}`
          end

      end

    end
  end
end