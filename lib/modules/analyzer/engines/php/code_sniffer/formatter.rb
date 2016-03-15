# Analyzer -> Engines -> PHP -> CodeSniffer -> formatter.rb
#
# To format/parse the output given from the engine

module Analyzer
  module Engines
    module PHP
      module CodeSniffer

        class Formatter

            def initialize branch
              @branch = branch
              @issue_categories = {}
              ActiveRecord::Base.connection_pool.with_connection do
                IssueCategory.find_each do |category|
                  @issue_categories[category.name.to_sym] = category.id
                end
              end
              @file_list = {}
              @config = ::Analyzer::Engines::PHP::CodeSniffer::Config
            end

            def xml_to_hash xml
                require 'nokogiri'
                file_array = Nokogiri::XML(xml).xpath("//file")
                errors = []
                file_array.each do |file|
                  file.elements.each do |error|
                    errors<< {
                      file_path: get_file(file["name"]).relative_path,
                      issue_text: error["message"],
                      begin_line: error["line"].to_i,
                      end_line: error["line"].to_i,
                      issue_column: error["column"],
                      source_code: get_source_code(file["name"],error["line"],error["line"]),
                      weight: get_source_weight(error["source"]),
                      engine: "phpcs",
                      engine_ruleset: error["source"],
                      version: @branch.current_version + 1,
                      issue_category_id: get_issue_category,
                      file_list_id: get_file(file["name"]).id,
                      branch_id: @branch.id
                    }
                  end
                end
                errors
            end

            def self.format xml, branch
              new(branch).xml_to_hash(xml)
            end

            def get_issue_category()
              @issue_categories[:style]
            end

            def get_source_code(file, begin_line, end_line)
              file = File.open(file)
              code = ""
              (begin_line.to_i - 1).times { file.gets }
              (end_line.to_i - (begin_line.to_i - 1)).times { code += file.gets }
              file.close
              code
            end

            def get_source_weight(source)
              @config::SNIFFS.each do |category, weight|
                return weight if category === source
              end
              return @config::DEFAULT_POINT
            end

            def get_file(path)
              ActiveRecord::Base.connection_pool.with_connection do
                @file_list[path.to_sym] ||= FileList.find_by(full_path: path)
              end
            end

          end
        end

      end
    end
  end