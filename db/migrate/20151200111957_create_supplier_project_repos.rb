class CreateSupplierProjectRepos < ActiveRecord::Migration
  def change
    create_table :supplier_project_repos do |t|
      t.string :username
      t.integer :supplier_project_id
      t.string :repo_name
      t.string :clone_url
      t.string :clone_path
      t.string :default_branch
      t.string :current_branch
      t.string :gpa
      t.integer :status
      t.text :error_message

      t.timestamps null: false
    end
  end
end
