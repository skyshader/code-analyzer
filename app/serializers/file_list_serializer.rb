class FileListSerializer < ActiveModel::Serializer

  attributes :id, :relative_path, :gpa, :grade, :code_issues_count

  belongs_to :repository do
    object.branch.repository
  end

  belongs_to :branch

  belongs_to :language do
    object.supported_language || {}
  end

  def code_issues_count
    object.code_issues.where(version: object.branch.current_version).count
  end

end
