module Stats
  module Generator

    class GPA

      def initialize(branch:)
        @branch = branch
      end

      def self.grade_files(branch:)
        new(branch: branch).process_files
      end

      def self.grade_repo(branch:)
        new(branch: branch).process_repo
      end


      def process_files
        FileList.get_files_to_process(@branch).each do |file|
          issue_ranges = []
          file.code_issues.where(version: @branch.current_version + 1).each do |issue|
            current_range = issue[:begin_line]..issue[:end_line]
            issue_ranges << current_range if issue_ranges.size == 0
            issue_ranges = replace_dup_ranges issue_ranges, current_range
          end
          puts issue_ranges
        end
      end


      def process_repo
      end


      private
      ##---------------------------------------------
      #
      # Helper methods starts here
      #
      ##---------------------------------------------

      def replace_dup_ranges ranges, current
        ranges.each_with_index do |range, index|
          if range.overlaps?(current)
            ranges[index] = [range.first, current.first].min..[range.last, current.last].max
          else
            ranges << current
          end
        end
        ranges
      end

    end

  end
end