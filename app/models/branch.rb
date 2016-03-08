class Branch < ActiveRecord::Base

  belongs_to :repository
  has_many :file_lists
  has_many :code_issues
  has_many :contributors
  has_many :commits

  # create a branch if it doesn't exist
  def self.setup_branch repository
    Branch.find_or_create_by(
      name: repository.current_branch,
      repository_id: repository.id
    )
  end


  def self.update_version branch
    CodeIssue.transaction do
      ActiveRecord::Base.connection_pool.with_connection do
        branch.current_version += 1
        branch.save
        CodeIssue.where(branch_id: branch.id, version: branch.current_version).update_all(status: 1)
      end
    end
  end


  def self.reset_version branch
    CodeIssue.transaction do
      ActiveRecord::Base.connection_pool.with_connection do
        CodeIssue.where(branch_id: branch.id, version: (branch.current_version + 1)).delete_all
      end
    end
  end

end
