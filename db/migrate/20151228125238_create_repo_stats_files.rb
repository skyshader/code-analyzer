class CreateRepoStatsFiles < ActiveRecord::Migration
  def change
    create_table :repo_stats_files do |t|
      t.integer :total_lines
      t.integer :lines_with_error
      t.integer :total_errors
      t.references :repo_category_stat, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
