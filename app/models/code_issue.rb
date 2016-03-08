class CodeIssue < ActiveRecord::Base

  belongs_to :issue_category
  belongs_to :file_list
  belongs_to :branch


  def self.store_results issues, branch
    CodeIssue.transaction do
      ActiveRecord::Base.connection_pool.with_connection do
        branch.code_issues.create(issues)
      end
    end
  end
  
end
