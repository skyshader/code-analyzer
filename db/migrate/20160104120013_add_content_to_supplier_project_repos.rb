class AddContentToSupplierProjectRepos < ActiveRecord::Migration
  def change
    add_column :supplier_project_repos, :content, :text
  end
end
