module Stats

  class LanguageGenerator

    def initialize(branch:)
      @branch = branch
      @stats = {}
    end

    def count_issues
      FileList.get_files_to_process(@branch).each do |file|
        @stats[file.language.to_sym] = {
          'issues_count' => 0,
          'files_count' => 0
        } if !@stats[file.language.to_sym]
        @stats[file.language.to_sym]['issues_count'] += file.code_issues.where(version: @branch.current_version + 1).count
        @stats[file.language.to_sym]['files_count'] += 1
      end
      @stats
    end
  end
end