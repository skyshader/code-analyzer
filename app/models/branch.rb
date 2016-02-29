class Branch < ActiveRecord::Base

  belongs_to :repository

  has_many :file_lists

  def self.create_branch repository
    Branch.find_or_create_by(
      name: repository.current_branch,
      repository_id: repository.id
    )
  end

end
