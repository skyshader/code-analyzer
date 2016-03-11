class CategoryStat < ActiveRecord::Base

  belongs_to :issue_category

  def self.store_results category_stats, branch
    CategoryStat.transaction do
      ActiveRecord::Base.connection_pool.with_connection do
        CategoryStat.create(category_stats)
      end
    end
  end

end
