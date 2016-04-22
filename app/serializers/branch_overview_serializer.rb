class BranchOverviewSerializer < ActiveModel::Serializer

  # attributes :repository, :branch, :category_stats, :language_stats, :files, :issues
  attributes :id, :name, :gpa, :current_version

  belongs_to :repository

  has_many :current_category_stats do
    stats = object.category_stats.where(version: object.current_version)
    stats ? stats : {}
  end

  has_many :current_language_stats do
    stats = object.language_stats.where(version: object.current_version)
    stats ? stats : {}
  end

  has_many :files do
    files = object.file_lists.limit(25)
    files ? files : {}
  end

  has_many :current_issues do
    issues = object.code_issues.where(version: object.current_version).limit(25)
    issues ? issues : {}
  end

  has_one :current_request do
    request = object.request_logs.find_by_status(1)
    request ? request : {}
  end

  has_one :last_completed_request do
    request = object.request_logs.where(is_complete: 1, status: 0).last
    request ? request : {}
  end

end
