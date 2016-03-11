module Stats
  module Generator

    class Category

      def initialize(branch:)
        @branch = branch
        @category_stats = []
      end


      def generate
        IssueCategory.find_each do |category|
          stats = {
            'issue_category_id' => category.id,
            'issue_count' => 0,
            'file_count' => 0,
            'branch_id' => @branch.id,
            'analysis_version' => @branch.current_version + 1
          }
          code_issues = category.code_issues.where(version: @branch.current_version + 1)
          stats['issue_count'] += code_issues.count
          
          stats['file_count'] += get_file_count(code_issues)
          @category_stats << stats
        end
        @category_stats
      end


      def get_file_count issues
        files = []
        issues.each do |issue|
          files << issue.file_list_id
        end
        files.uniq!
        files.count
      end

    end

  end
end