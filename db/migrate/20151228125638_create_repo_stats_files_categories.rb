class CreateRepoStatsFilesCategories < ActiveRecord::Migration
  def change
    create_table :repo_stats_files_categories do |t|
      t.integer :issues_count
      t.references :code_category, index: true, foreign_key: true
      t.references :repo_stats_file, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
