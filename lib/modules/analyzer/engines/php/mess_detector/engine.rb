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
            @batches.each do |batch|
              result = process_batch batch
              puts result
              # format results
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