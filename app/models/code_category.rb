class CodeCategory < ActiveRecord::Base
	has_many :code_review, through: :code_review_category
end
