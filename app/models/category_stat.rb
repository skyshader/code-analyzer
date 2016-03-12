class CategoryStat < ActiveRecord::Base

  belongs_to :issue_category
  belongs_to :branch

end
