class Branch < ActiveRecord::Base

  belongs_to :repository
  has_many :file_lists
  has_many :contributors
  has_many :commits

  # create a branch if it doesn't exist
  def self.setup_branch repository
    Branch.find_or_create_by(
      name: repository.current_branch,
      repository_id: repository.id
    )
  end

end
