module Stats
  module Generator

    class Category

      def initialize(branch:)
        @branch = branch
        @category_stats = []
      end


      ##
      # Calculate stats on the basis of issue categories
      #
      def generate
        IssueCategory.find_each do |category|
          stat = {
            issue_category_id: category.id,
            issues_count: 0,
            files_count: 0,
            version: @branch.current_version + 1
          }
          code_issues = CodeIssue.get_category_issues(@branch, category)
          stat[:issues_count] += CodeIssue.get_category_issues_count(code_issues)
          
          stat[:files_count] += get_file_count(code_issues)
          @category_stats << stat
        end
        @category_stats
      end


      ##
      # Get total unique files count for a certain issue category
      #
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