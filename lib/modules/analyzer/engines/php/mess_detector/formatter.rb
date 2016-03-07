# Analyzer -> Engines -> PHP -> MessDetector -> formatter.rb
#
# To format/parse the output given from the engine

require 'rubygems'
require 'nokogiri'

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
                  source_code: ,                  
                  weight: ,
                  engine: "phpmd",
                  engine_ruleset: ,
                  issue_category: get_issue_category_id(error["rule"])
                }
              end
            end
            errors
          end

          def get_issue_category_id(rule)
            
          end

        end
      end
    end
  end
end