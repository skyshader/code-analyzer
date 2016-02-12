class SupplierProjectRepo < ActiveRecord::Base
	has_many :code_review
	has_many :repo_contributors
end
