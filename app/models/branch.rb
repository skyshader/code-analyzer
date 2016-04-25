class Branch < ActiveRecord::Base

  belongs_to :repository
  has_many :file_lists
  has_many :code_issues
  has_many :contributors
  has_many :commits
  has_many :request_logs
  has_many :category_stats
  has_many :language_stats

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
        LanguageStat.where(branch_id: branch.id, version: (branch.current_version + 1)).delete_all
        CategoryStat.where(branch_id: branch.id, version: (branch.current_version + 1)).delete_all
      end
    end
  end


  def self.update_score branch, score
    gpa = Utility::GPAHelper.gpa(score)
    ActiveRecord::Base.connection_pool.with_connection do
      Branch.transaction do
        branch.update(gpa: gpa, grade: score)
      end
    end
  end


  #---------------------------------------------------
  # For API
  # Not running on thread
  #---------------------------------------------------

  def self.get_default_branch repository_id
    repository = Repository.find(repository_id)
    branch = repository.branches.where(name: repository.default_branch).first
    raise ActiveRecord::RecordNotFound unless branch
    branch
  end


  def self.get_branch name, repository_id
    branch = Branch.find_by_name_and_repository_id(name, repository_id)
    raise ActiveRecord::RecordNotFound unless branch
    branch
  end

end
