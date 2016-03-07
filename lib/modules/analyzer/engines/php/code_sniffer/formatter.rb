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
                      :begin_line => error["line"],
                      :end_line => error["line"],
                      :issue_column => error["column"],
                      :source_code => error["source"]
                      :severity => error["severity"],
                      :issue => error["message"],
                    }
                  end
                end
            end
            # errors
        end

      end
    end
  end
end