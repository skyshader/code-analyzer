class AddOwnerToSupplierProjectRepos < ActiveRecord::Migration
  def change
    add_column :supplier_project_repos, :owner, :string
  end
end
