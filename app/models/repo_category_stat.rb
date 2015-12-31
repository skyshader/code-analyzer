class RepoCategoryStat < ActiveRecord::Base
  belongs_to :supplier_project_repo
  belongs_to :code_category
end
