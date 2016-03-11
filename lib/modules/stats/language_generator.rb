module Stats

  class LanguageGenerator

    def initialize(branch:)
      @branch = branch
      @stats_temp = {}
      @stats = []
    end

    def count_issues
      FileList.get_files_to_process(@branch).each do |file|
        @stats_temp[file.language.to_sym] = {
          'issues_count' => 0,
          'files_count' => 0
        } if !@stats_temp[file.language.to_sym]

        @stats_temp[file.language.to_sym]['issues_count'] += file.code_issues.where(version: @branch.current_version + 1).count
        @stats_temp[file.language.to_sym]['files_count'] += 1
      end

     formatter
    end

    def formatter
      @stats_temp.each do |lang, stats|
        lang = SupportedLanguage.find_by(name: lang)
        @stats << {
          supported_language_id: lang.id
          branch_id: @branch.id
          issues_count: stats['issues_count']
          files_count: stats['files_count']
        }
      end

      @stats
    end
  end
end