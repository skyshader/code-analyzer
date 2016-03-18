class BranchSerializer < ActiveModel::Serializer

  attributes :id, :name, :gpa
  
  belongs_to :repository
  has_many :file_lists
  has_many :code_issues
  has_many :contributors
  has_many :commits
  has_many :request_logs
  has_many :category_stats
  has_many :language_stats

end
