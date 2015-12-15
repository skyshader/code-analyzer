class CreateSupplierProjectRepos < ActiveRecord::Migration
  def change
    create_table :supplier_project_repos do |t|
      t.string :username
      t.string :repo_name
      t.string :clone_url
      t.string :clone_path
      t.string :default_branch
      t.string :current_branch
      t.string :gpa
      t.integer :analysis_status
      t.integer :status
      t.integer :supplier_project_id

      t.timestamps null: false
    end
  end
end
