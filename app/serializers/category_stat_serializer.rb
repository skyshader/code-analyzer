class CategoryStatSerializer < ActiveModel::Serializer
  
  attributes :issues_count, :files_count
  
  belongs_to :issue_category

end
