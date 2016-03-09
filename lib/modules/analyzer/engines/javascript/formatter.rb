# Analyzer -> Engines -> JavaScript -> engine.rb
#
# To format/parse the output given from the engine

module Analyzer
  module Engines
    module Javascript

      class Formatter

        def initialize branch
            @branch = branch
            @issue_categories = {}
            IssueCategory.find_each do |category|
            @issue_categories[category.name.to_sym] = category.id
            end
            @file_list = {}
            @config = ::Analyzer::Engines::Javascript::Config
        end

        def xml_to_hash xml
            require 'nokogiri'
            file_array = Nokogiri::XML(xml).xpath("//file")
            errors = []
            file_array.each do |file|
                file.elements.each do |error|
                    errors<< {
                        file_path: file["name"],
                        issue_text: error["message"],
                        begin_line: error["line"].to_i,
                        end_line: error["line"].to_i,
                        issue_column: error["column"],
                        source_code: get_source_code(file["name"],error["line"],error["line"]),
                        weight: get_source_weight(error["source"]),
                        engine: "eslint",
                        engine_ruleset: error["source"],
                        version: @branch.current_version + 1,
                        issue_category_id: "style",
                        file_list_id: get_file_id(file["name"]),
                        branch_id: @branch.id
                    }
                end
            end
            errors
        end

        def self.format xml, branch
            new(branch).xml_to_hash(xml)
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
          @config::CATEGORY.each do |category, weight|
            return weight if category === source
          end
          return @config::DEFAULT_POINT
        end

        def get_file_id(path)
          @file_list[path.to_sym] ||= FileList.find_by(full_path: path).id
        end

      end

    end
  end
end