module Stats

  class Process

    def initialize (branch:)
      @branch = branch
    end


    def run
      #category_stats = Stats::Generator::Category.new(branch: @branch).generate
      #language_stats = Stats::Generator::Language.new(branch: @branch).generate

      CategoryStat.transaction do
        ActiveRecord::Base.connection_pool.with_connection do
          @branch.category_stats.create(category_stats)
          @branch.language_stats.create(language_stats)
        end
      end
      Rails.logger.debug "------ Generated Stats ------"
      Stats::Generator::GPA.grade_files(branch: @branch)
      Stats::Generator::GPA.grade_repo(branch: @branch)
      Rails.logger.debug "------ Generated GPA ------"
    end

  end

end