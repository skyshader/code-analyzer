class CodeIssue < ActiveRecord::Base

  belongs_to :issue_category
  belongs_to :file_list
  belongs_to :branch


  def self.store_results issues, branch
    CodeIssue.transaction do
      ActiveRecord::Base.connection_pool.with_connection do
        discard_old_issues branch
        branch.code_issues.create(issues)
      end
    end
  end


  def self.discard_old_issues branch
    CodeIssue.where(branch_id: branch.id, status: 1).update_all(status: 0)
  end
  
end
