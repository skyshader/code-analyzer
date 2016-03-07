# Analyzer -> Engines -> PHP -> MessDetector -> formatter.rb
#
# To format/parse the output given from the engine

module Analyzer
  module Engines
    module PHP
      module MessDetector

        class Formatter


          def self.xml_to_hash xml
            xml_doc = Nokogiri::XML(xml)
            file_array = xml_doc.xpath("//file")
            errors = []
            file_array.each do |file|
              file.elements.each do |error|
                errors << {
                  file_path: file["name"],
                  issue_text: error.inner_text,
                  begin_line: error["beginline"],
                  end_line: error["endline"],
                  issue_column: nil,
                  source_code: get_source_code(
                    file["name"], [
                      error["beginline"],
                      error["endline"]
                    ]
                  ),
                  weight: get_rule_weight(error["rule"]),
                  engine: "phpmd",
                  engine_ruleset: error["rule"],
                  issue_category_id: get_issue_category(error["rule"]).id || default_category.id
                }
              end
            end
            errors
          end

          def get_issue_category(rule)
            Analyzer::Engines::PHP::MessDetector::Config::CATEGORIES.each do |category, data|
              if category == rule
                return IssueCategory.find_by(name: data.first)                
              end
            end
          end

          def default_category
            IssueCategory.find_by(name: "style")
          end

          def get_rule_weight(rule)
            Analyzer::Engines::PHP::MessDetector::Config::CATEGORIES.each do |category, data|
              if category == rule
                return data.last                
              end
          end

          def get_source_code(file, line)
            file = File.open(file)
            code = ""
            (line.first - 1).times { file.gets }
            (line.last - (line.first - 1)).times { code += file.gets }
          end
      end
    end
  end
end