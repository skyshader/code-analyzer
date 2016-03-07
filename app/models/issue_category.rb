class IssueCategory < ActiveRecord::Base

  has_many :code_issues

end
