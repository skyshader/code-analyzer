class CodeIssue < ActiveRecord::Base

  belongs_to :issue_category
  belongs_to :file_list
  belongs_to :branch
  
end
