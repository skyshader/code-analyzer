module Stats
    class ProcessStats
        def initialize (branch:)
            @branch = branch
        end
        def generate
            Stats::LanguageGenerator.new(branch: @branch).count_issues
            Stats::CategoryGenerator.new(branch: @branch).count_issues
        end
    end
end