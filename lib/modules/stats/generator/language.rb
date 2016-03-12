module Stats
  module Generator

    class Language

      def initialize(branch:)
        @branch = branch
        @languages = {}
        @language_stats = []
      end


      ##
      # Calculate stats on the basis of languages
      #
      def generate
        FileList.get_files_to_process(@branch).each do |file|
          language = get_language(file)
          stat = get_stat(language)

          stat[:issues_count] += file.code_issues.where(version: @branch.current_version + 1).count
          stat[:files_count] += 1
        end
       @language_stats
      end


      def does_stat_exists? language_id
        @language_stats.any? { |h| h[:supported_language_id] === language_id }
      end


      ##
      # Cache languages for multiple usage
      #
      def get_language file
        @languages[file.supported_language_id] ||= file.supported_language
      end


      def get_stat language
        @language_stats << {
          supported_language_id: language.id,
          issues_count: 0,
          files_count: 0,
          version: @branch.current_version + 1
        } if !does_stat_exists?(language.id)

        @language_stats.find { |h| h[:supported_language_id] === language.id }
      end

    end

  end
end