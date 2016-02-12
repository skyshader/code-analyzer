class CreateRepoContributors < ActiveRecord::Migration
  def up
    create_table :repo_contributors do |t|
      t.string :name
      t.string :email
      t.integer :additions
      t.integer :deletions
      t.integer :commits
      t.references :supplier_project_repo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :repo_contributors, column: :supplier_project_repo_id
    drop_table :repo_contributors
  end
end
