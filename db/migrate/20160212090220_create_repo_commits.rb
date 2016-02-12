class CreateRepoCommits < ActiveRecord::Migration
  def up
    create_table :repo_commits do |t|
      t.string :sha
      t.date :date
      t.datetime :full_date
      t.integer :additions
      t.integer :deletions
      t.integer :files_changed
      t.references :repo_contributor, index: true, foreign_key: true
      t.references :supplier_project_repo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :repo_commits, column: :repo_contributor_id
    remove_foreign_key :repo_commits, column: :supplier_project_repo_id
    drop_table :repo_commits
  end
end
