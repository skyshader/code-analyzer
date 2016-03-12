module Stats
  module Generator

    class Language

      def initialize(branch:)
        @branch = branch
        @languages = {}
        @stats = {}
        @s = []
      end


      def generate
        FileList.get_files_to_process(@branch).each do |file|
          language = get_language(file).to_sym
          @stats[language] = {
            'issues_count' => 0,
            'files_count' => 0
          } if !@stats[language]

          @stats[language]['issues_count'] += file.code_issues.where(version: @branch.current_version + 1).count
          @stats[language]['files_count'] += 1
        end
       formatter
      end


      def get_language file
        @languages[file.supported_language_id] ||= file.supported_language.name
      end


      def formatter
        @stats.each do |lang, stats|
          lang = SupportedLanguage.where(name: lang).first
          @s << {
            supported_language_id: lang.id,
            branch_id: @branch.id,
            issues_count: stats['issues_count'],
            files_count: stats['files_count']
          }
        end
        @s
      end
    end

  end
end