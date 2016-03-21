class BranchSerializer < ActiveModel::Serializer

  attributes :id, :name, :gpa
  
  belongs_to :repository


  has_one :current_request do
    request = object.request_logs.find_by_status(1)
    request ? request : {}
  end

  has_one :last_completed_request do
    request = object.request_logs.where(is_complete: 1, status: 0).last
    request ? request : {}
  end

end
