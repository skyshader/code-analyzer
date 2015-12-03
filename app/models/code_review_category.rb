class CodeReviewCategory < ActiveRecord::Base
  belongs_to :code_category
  belongs_to :code_review
end
