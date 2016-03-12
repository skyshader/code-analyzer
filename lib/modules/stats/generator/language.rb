module Stats
  module Generator

    class Language

      def initialize(branch:)
        @branch = branch
        @language_stats = []
      end


      ##
      # Calculate stats on the basis of languages
      #
      def generate
        SupportedLanguage.find_each do |lang|
          files = lang.file_lists
          @language_stats << {
             supported_language_id: lang.id,
             issues_count: get_issue_count(files),
             files_count: files.count,
             version: @branch.current_version + 1
           }
        end
        @language_stats
      end

      def get_issue_count files
        count = 0
        files.each do |file|
          count += file.code_issues.where(version: @branch.current_version + 1).count
        end
        count
      end

    end

  end
end