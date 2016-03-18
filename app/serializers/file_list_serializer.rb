class FileListSerializer < ActiveModel::Serializer

  attributes :id, :relative_path

  has_many :code_issues
  belongs_to :branch
  belongs_to :supported_language

end
