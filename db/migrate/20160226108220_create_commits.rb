class CreateCommits < ActiveRecord::Migration
  def up
    create_table :commits do |t|
      t.string :sha
      t.date :date
      t.datetime :full_date
      t.integer :additions
      t.integer :deletions
      t.integer :files_changed
      t.references :contributor, index: true, foreign_key: true
      t.references :repository, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :commits, column: :contributor_id
    remove_foreign_key :commits, column: :repository_id
    drop_table :commits
  end
end
