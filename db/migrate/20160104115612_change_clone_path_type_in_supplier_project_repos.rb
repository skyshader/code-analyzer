class ChangeClonePathTypeInSupplierProjectRepos < ActiveRecord::Migration
  def change
  	change_column :supplier_project_repos, :clone_path, :text
  end
end
