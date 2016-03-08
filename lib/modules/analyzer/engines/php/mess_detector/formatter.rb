# Analyzer -> Engines -> PHP -> MessDetector -> formatter.rb
#
# To format/parse the output given from the engine

module Analyzer
  module Engines
    module PHP
      module MessDetector

        class Formatter


          def initialize
            @issue_categories = {}
            IssueCategory.find_each do |category|
              @issue_categories[category.name.to_sym] = category.id
            end
          end


          def xml_to_hash xml
            require 'nokogiri'
            xml_doc = Nokogiri::XML(xml)
            file_array = xml_doc.xpath("//file")
            errors = []
            file_array.each do |file|
              file.elements.each do |error|
                errors << {
                  file_path: file["name"],
                  issue_text: error.inner_text,
                  begin_line: error["beginline"].to_i,
                  end_line: error["endline"].to_i,
                  issue_column: nil,
                  source_code: get_source_code(file["name"], error["beginline"], error["endline"]),
                  weight: get_rule_weight(error["rule"]),
                  engine: "phpmd",
                  engine_ruleset: error["rule"],
                  issue_category: get_issue_category(error["rule"]) || default_category
                }
              end
            end
            errors
          end


          def self.format xml
            new.xml_to_hash(xml)
          end

          def get_issue_category(rule)
            Analyzer::Engines::PHP::MessDetector::Config::CATEGORIES.each do |category, data|
              if category === rule
                return @issue_categories[data.first.to_sym]
              end
            end
          end

          def default_category
            return @issue_categories[:style]
          end

          def get_rule_weight(rule)
            Analyzer::Engines::PHP::MessDetector::Config::CATEGORIES.each do |category, data|
              return data.last if category === rule
            end
          end

          def get_source_code(file, begin_line, end_line)
            file = File.open(file)
            code = ""
            (begin_line.to_i - 1).times { file.gets }
            (end_line.to_i - (begin_line.to_i - 1)).times { code += file.gets }
            file.close
            code
          end

        end

      end
    end
  end
end