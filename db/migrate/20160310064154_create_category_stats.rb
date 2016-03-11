class CreateCategoryStats < ActiveRecord::Migration
  def change
    create_table :category_stats do |t|
      t.integer :category_id
      t.integer :issue_count
      t.integer :file_count
      t.integer :analysis_version
      t.integer :branch_id
      t.timestamps null: false
    end
  end
end
