class AddIsPrivateToSupplierProjectRepos < ActiveRecord::Migration
  def change
    add_column :supplier_project_repos, :is_private, :integer, :default => 0
  end
end
