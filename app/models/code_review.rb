class CodeReview < ActiveRecord::Base
	belongs_to :supplier_project_repo
	has_many :code_review_category, dependent: :destroy
	has_many :code_category, through: :code_review_category
end
