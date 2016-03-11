class CreateCategoryStats < ActiveRecord::Migration
  def up
    create_table :category_stats do |t|
      t.integer :issue_count
      t.integer :file_count
      t.integer :analysis_version
      t.references :branch,  index: true, foreign_key: true
      t.references :issue_category, index: true, foreign_key: true

      t.timestamps null: false

    end
  end

  def down
    remove_foreign_key :category_stats, column: :branch_id
    remove_foreign_key :category_stats, column: :issue_category_id
    drop_table :category_stats
  end
end
