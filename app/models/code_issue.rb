class CodeIssue < ActiveRecord::Base

  self.primary_key = "id"

  belongs_to :issue_category
  belongs_to :file_list
  belongs_to :branch


  def self.store_results issues, branch
    CodeIssue.transaction do
      ActiveRecord::Base.connection_pool.with_connection do
        CodeIssue.create(issues)
      end
    end
  end

  def self.get_file_issues branch, file
    ActiveRecord::Base.connection_pool.with_connection do
      CodeIssue.where(version: branch.current_version + 1, file_list_id: file.id)
    end
  end

  def self.get_file_issues_count branch, file
    ActiveRecord::Base.connection_pool.with_connection do
      get_file_issues(branch, file).count
    end
  end

  def self.get_category_issues branch, category
    ActiveRecord::Base.connection_pool.with_connection do
      CodeIssue.where(branch_id: @branch.id, version: @branch.current_version + 1, issue_category_id: category.id)
    end
  end

  def self.get_category_issues_count issues
    ActiveRecord::Base.connection_pool.with_connection do
      issues.count
    end
  end

  
end
