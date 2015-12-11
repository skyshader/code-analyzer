class CreateRepoCategoryStats < ActiveRecord::Migration
  def up
    create_table :repo_category_stats do |t|
      t.integer :issues_count
      t.integer :version
      t.references :supplier_project_repo, index: true, foreign_key: true
      t.references :code_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
  	remove_foreign_key :repo_category_stats, column: :supplier_project_repo_id
  	remove_foreign_key :repo_category_stats, column: :code_category_id
  	drop_table :repo_category_stats
  end
end
