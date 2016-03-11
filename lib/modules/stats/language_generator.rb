module Stats

  class LanguageGenerator

    def initialize(branch:)
      @branch = branch
      @language_stats = {}
    end

    def count_issues

      FileList.get_files_to_process(@branch).each do |file|
        @language_stats[file.language.to_sym] = {
          'issues_count' => 0,
          'files_count' => 0
        } if !@language_stats[file.language.to_sym]
        @language_stats[file.language.to_sym]['issues_count'] += file.code_issues.where(version: @branch.current_version + 1).count
        @language_stats[file.language.to_sym]['files_count'] += 1
      end

      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
      puts "#{@language_stats}"
      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"

  end
end