module Stats
  class CategoryGenerator


    def initialize(branch:)
      @branch = branch
      @stats = {}
    end

    def count_issues
      IssueCategory.find_each do |category|
        @stats[category.name.to_sym] = {
          'issues_count' => 0,
          'files_count' => 0
        } if !@stats[category.name.to_sym]
        @stats[category.name.to_sym]['issues_count'] += category.code_issues.where(version: @branch.current_version + 1).count
        files = []
        category.code_issues.where(version: @branch.current_version + 1).each do |issue|
          files << issue.file_list.id
        end
        files.uniq!
        @stats[category.name.to_sym]['files_count'] += files.count
      end

      @stats
    end


  end
end