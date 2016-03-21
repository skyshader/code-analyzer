class FileListSerializer < ActiveModel::Serializer

  attributes :id, :relative_path

  belongs_to :repository do
    object.branch.repository
  end

  belongs_to :branch
  belongs_to :language do
    object.supported_language || {}
  end

end
