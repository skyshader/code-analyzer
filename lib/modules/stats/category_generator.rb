module Stats
  class CategoryGenerator


    def initialize(branch:)
      @branch = branch
      @stats = {}
      @category_stats = []
    end

    def count_issues
      IssueCategory.find_each do |category|
        @stats= {
          'issue_category_id' => category.id,
          'issue_count' => 0,
          'file_count' => 0,
          'branch_id' => @branch.id,
          'analysis_version' => @branch.current_version + 1
        }
        @stats['issue_count'] += category.code_issues.where(version: @branch.current_version + 1).count
        files = []
        category.code_issues.where(version: @branch.current_version + 1).each do |issue|
          files << issue.file_list.id
        end
        files.uniq!
        @stats['file_count'] += files.count
        @category_stats << @stats
      end
      @category_stats
    end
  end
end