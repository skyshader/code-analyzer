# Analyzer -> Engines -> PHP -> MessDetector -> engine.rb
#
# The engine that will run phpmd on project files

module Analyzer
  module Engines
    module PHP
      module MessDetector

        class Engine

          attr_reader :repository, :branch, :batches, :directory, :engine_config, :engine_config

          def initialize(repository:, branch:, batches:)
            @repository = repository
            @branch = branch
            @batches = batches
            @directory = repository.directory
            @engine_config = ::Analyzer::Engines::PHP::MessDetector::Config
            @engine_formatter = ::Analyzer::Engines::PHP::MessDetector::Formatter
          end


          def run
            puts ">>>>>>>> Running PHP Mess Detector <<<<<<<<"
            @batches.each do |batch|
              result_xml = process_batch batch
              result_hash = @engine_formatter.xml_to_hash result_xml
              puts result_hash
              # store data
            end
            puts "------------------------------------------------"
          rescue => e
            Rails.logger.debug "Exception ---------------------" + e.message + " >>> " + e.backtrace.to_s
            raise
          end

          private

          def process_batch batch
            files = nil
            batch.each do |file|
              files = '' if !files
              files += file[:full_path] + ","
            end
            files.chomp!(',')
            result = execute_phpmd_command(files)
          end


          def execute_phpmd_command files
            `phpmd #{files} #{@engine_config::RESULT_FORMAT} #{@engine_config::RULESETS}`
          end

        end

      end
    end
  end
end