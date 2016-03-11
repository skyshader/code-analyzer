module Stats

  class LanguageGenerator

    def initialize(branch:)
      @branch = branch
      @issue_count = Hash.new(0)
    end

    def count_issues
      CodeIssue.where(version: @branch.current_version+1).find_each do |issue|
        @issue_count[issue.file_list.language] += 1
      end

      puts "------------------------------------------------------"
      puts "Language stats"
      puts "------------------------------------------------------"
      puts "#{@issue_count}"
    end

  end
end