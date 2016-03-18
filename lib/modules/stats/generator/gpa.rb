module Stats
  module Generator

    class GPA

      DEFAULT_SAFE_POINTS = 300000.freeze
      GPA_DEFAULT = 4.freeze

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
          issue_ranges, error_points = [], 0
          CodeIssue.get_file_issues(@branch, file).each do |issue|
            error_points += issue[:weight]
            current_range = issue[:begin_line]..issue[:end_line]
            issue_ranges << current_range if issue_ranges.size === 0
            issue_ranges = replace_dup_ranges(issue_ranges, current_range)
          end
          score = generate_file_score(file, issue_ranges, error_points)
          FileList.update_score(file, score)
        end
      end


      def process_repo
        total_gpa = total_files = 0
        gpa = 0
        FileList.get_files_to_process(@branch).each do |file|
          unless file.gpa.nil?
            total_gpa += file.gpa
            total_files += 1
          end
        end
        gpa = (total_gpa.to_f / total_files).round(2) if total_files > 0
        Branch.update_gpa(@branch, gpa)
      end


      private
      ##---------------------------------------------
      #
      # Helper methods starts here
      #
      ##---------------------------------------------

      def generate_file_score file, issue_ranges, error_points
        error_lines = count_ranges(issue_ranges)
        safe_lines = file[:lines_code].to_i - error_lines
        safe_lines = 0 if safe_lines < 0
        safe_points = safe_lines * DEFAULT_SAFE_POINTS
        expected_points = file[:lines_code] * DEFAULT_SAFE_POINTS
        actual_points = expected_points - error_points
        actual_points = 0 if actual_points < 0
        ((actual_points.to_f / expected_points.to_f) * GPA_DEFAULT).round(2)
      end

      def replace_dup_ranges ranges, current
        replaced = false
        ranges.each_with_index do |range, index|
          if range.overlaps?(current)
            ranges[index] = [range.first, current.first].min..[range.last, current.last].max
            replaced = true
          end
        end
        ranges << current unless replaced
        ranges.uniq
      end


      def count_ranges ranges
        count = 0
        ranges.each do |range|
          count += range.size
        end
        count
      end

    end

  end
end