class SupplierProjectRepo < ActiveRecord::Base
	has_many :code_reviews
	has_many :repo_contributors
	has_many :repo_logs
end
