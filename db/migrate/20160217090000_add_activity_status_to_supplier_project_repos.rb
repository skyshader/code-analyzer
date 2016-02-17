class AddActivityStatusToSupplierProjectRepos < ActiveRecord::Migration
  def change
    add_column :supplier_project_repos, :activity_status, :integer, :default => 0
  end
end
