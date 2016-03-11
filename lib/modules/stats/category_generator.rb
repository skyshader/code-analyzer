module Stats
  class CategoryGenerator


    def initialize(branch:)
      @branch = branch
      @stat = {}
    end

    def count_issues
      IssueCategory.find_each do |category|
        @stat[category.name.to_sym] = {
          'issues_count' => 0,
          'files_count' => 0
        } if !@stat[category.name.to_sym]
        @stat[category.name.to_sym]['issues_count'] += category.code_issues.where(version: @branch.current_version + 1).count
        files = []
        category.code_issues.where(version: @branch.current_version + 1).each do |issue|
          # issue.file_list.find_each do |file|
        #     files << file.id
        #   end
        puts "#{issue}\n\n"
        # end
        # files.uniq!
        # @stat[category.name.to_sym]['files_count'] += files.count
      end
      puts "---------------------------------------------"
      puts "Category stats"
      puts "---------------------------------------------"
      puts @stat
    end


  end
end