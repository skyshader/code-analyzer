# Analyzer -> Engines -> PHP -> MessDetector -> formatter.rb
#
# To format/parse the output given from the engine

module Analyzer
  module Engines
    module PHP
      module MessDetector

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
            @config = ::Analyzer::Engines::PHP::MessDetector::Config
          end


          def xml_to_hash xml
            require 'nokogiri'
            file_array = Nokogiri::XML(xml).xpath("//file")
            errors = []
            file_array.each do |file|
              file.elements.each do |error|
                errors << {
                  file_path: get_file(file["name"]).relative_path,
                  issue_text: error.inner_text,
                  begin_line: error["beginline"].to_i,
                  end_line: error["endline"].to_i,
                  issue_column: nil,
                  source_code: get_source_code(file["name"], error["beginline"], error["endline"]),
                  weight: get_rule_weight(error["rule"]),
                  engine: "phpmd",
                  engine_ruleset: error["rule"],
                  version: @branch.current_version + 1,
                  issue_category_id: get_issue_category(error["rule"]),
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


          def get_issue_category(rule)
            @config::CATEGORIES.each do |category, data|
              if category === rule
                return @issue_categories[data.first.to_sym]
              end
            end
            @issue_categories[:style]
          end


          def get_rule_weight(rule)
            @config::CATEGORIES.each do |category, data|
              return data.last if category === rule
            end
            @config::DEFAULT_POINT
          end


          def get_source_code(file, begin_line, end_line)
            Utility::FileHandler.extract_source_code file, begin_line, end_line
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