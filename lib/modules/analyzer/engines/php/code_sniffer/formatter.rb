# Analyzer -> Engines -> PHP -> CodeSniffer -> formatter.rb
#
# To format/parse the output given from the engine

module Analyzer
  module Engines
    module PHP
      module CodeSniffer

        class Formatter
            def self.xml_to_hash xml
                # @SNIFFS = Analyzer::Engines::PHP::CodeSniffer::SNIFFS
                xml_doc = Nokogiri::XML(xml)
                file_array = xml_doc.xpath("//file")
                errors = []
                file_array.each do |file|
                  file.elements.each do |error|
                    errors<< {
                      :file_path => file["name"],
                      :issue_text => error["message"],
                      :begin_line => error["line"].to_i,
                      :end_line => error["line"].to_i,
                      :issue_column => error["column"],
                      :source_code => get_source_code(file["name"],error["line"],error["line"])
                      :weight => get_source_weight(error["source"]),
                      :engine => "phpcs",
                      :engine_ruleset => error["source"],
                      :issue_category => "style"
                    }
                  end
                end
                errors
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
              Analyzer::Engines::PHP::CodeSniffer::Config::SNIFFS.each do |category, weight|
                return weight if category === source
              end
              return Analyzer::Engines::PHP::CodeSniffer::Config::DEFAULT_POINT
            end

          end
        end

      end
    end
  end
end