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
          files = FileList.get_files(@branch, lang)
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
          count += CodeIssue.get_file_issues_count(@branch, file)
        end
        count
      end

    end

  end
end