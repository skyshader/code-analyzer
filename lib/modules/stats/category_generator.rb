module Stats
  class CategoryGenerator


    def initialize
      @issue_count = Hash.new(0)
      @file_count = Hash.new(0)
    end

    def analyze_stats
      marked_file_list_id = []
      CodeIssue.find_each do |issue|
        @issue_count["#{issue.issue_category_id}"] += 1
        if !(marked_file_list_id.include? issue.file_list_id)
          @file_count["#{issue.issue_category_id}"] += 1
        end
      end
      puts "---------------------------------------------"
      puts @issue_count
      puts @file_count
    end


  end
end