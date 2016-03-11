module Stats
    class ProcessStats
        def initialize (branch:)
            @branch = branch
        end
        def generate
            # language_stats = Stats::LanguageGenerator.new(branch: @branch).count_issues
            puts "Generate"
            category_stats = Stats::CategoryGenerator.new(branch: @branch).count_issues
            puts "Returned"
            # puts language_stats
            # puts category_stats
        end
    end
end