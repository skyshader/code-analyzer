class CreateCodeReviews < ActiveRecord::Migration
  def up
    create_table :code_reviews do |t|
      t.string :issue_type
      t.string :check_name
      t.text :description
      t.string :engine_name
      t.string :file_path
      t.integer :line_begin
      t.integer :line_end
      t.string :remediation_points
      t.references :supplier_project_repo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :code_reviews, column: :supplier_project_repo_id
    drop_table :code_reviews
  end
end
