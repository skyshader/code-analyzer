module Stats

  class Process

    def initialize (branch:)
      @branch = branch
    end


    def run
      category_stats = Stats::Generator::Category.new(branch: @branch).generate
      language_stats = Stats::Generator::Language.new(branch: @branch).generate
      
      CategoryStat.transaction do
        ActiveRecord::Base.connection_pool.with_connection do
          @branch.category_stats.create(category_stats)
          @branch.language_stats.create(language_stats)
        end
      end
    end

  end

end