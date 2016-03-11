class IssueCategory < ActiveRecord::Base

  has_many :code_issues
  has_many :category_stats

end
