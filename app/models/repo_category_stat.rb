class RepoCategoryStat < ActiveRecord::Base
  belongs_to :supplier_project_repo_id
  belongs_to :code_category_id
end
