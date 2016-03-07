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
                  engine: "phpmd",
                  file_path: file["name"],
                  begin_line: error["beginline"],
                  end_line: error["endline"],
                  issue_column: nil,
                  severity: nil,
                  issue_text: error.inner_text,
                  source: error["rule"],
                  priority: error["priority"]
                }
              end
            end
            errors
          end

        end
      end
    end
  end
end