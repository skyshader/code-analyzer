module Stats
    class ProcessStats
        def initialize (branch:)
            @branch = branch
        end
        def generate
            language_stats = Stats::LanguageGenerator.new(branch: @branch).count_issues
            category_stats = Stats::CategoryGenerator.new(branch: @branch).count_issues

            puts language_stats
            puts category_stats

            #LanguageStat.create(language_stats)
        end
    end
end