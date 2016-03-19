class RequestLogSerializer < ActiveModel::Serializer
  
  attributes :id, :request_type, :is_waiting, :is_active, :is_complete, :is_error, :branch_id, :status

end
