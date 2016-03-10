module Stats

  class LanguageGenerator

    def initialize
      @issue_count = Hash.new(0)
    end

    def count_issues
      CodeIssue.find_each do |issue|
        @issue_count[issue.file_list.languag e] += 1
      end

      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
      puts "#{@issue_count}"
      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
      puts "-----------------------------------------------------------------------"
    end

  end
end