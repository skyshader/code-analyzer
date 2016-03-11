module Stats
    class ProcessStats
        def initialize (branch:)
            @branch = branch
        end
        def generate
            # language_stats = Stats::LanguageGenerator.new(branch: @branch).count_issues
            CategoryStat.store_results Stats::CategoryGenerator.new(branch: @branch).count_issues, @branch
        end
    end
end