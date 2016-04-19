class LanguageStatSerializer < ActiveModel::Serializer

  attributes :issues_count, :files_count
  
  belongs_to :supported_language

end
