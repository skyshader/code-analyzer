module Stats
  class CategoryGenerator


    def initialize(branch:)
      puts "inisde"
      @branch = branch
      @category_stats = []
      @stats = {}
    end

    def count_issues
      IssueCategory.find_each do |category|
        @stats= {
          'issue_category_id' => category.id
          'issues_count' => 0,
          'files_count' => 0,
          'branch_id' => @branch.id,
          'analysis_version' => @branch.current_version + 1
        }
        @stats['issues_count'] += category.code_issues.where(version: @branch.current_version + 1).count
        files = []
        category.code_issues.where(version: @branch.current_version + 1).each do |issue|
          files << issue.file_list.id
        end
        files.uniq!
        @stats['files_count'] += files.count
        @category_stats << @stats
      end
      puts @category_stats
    end

  end
end