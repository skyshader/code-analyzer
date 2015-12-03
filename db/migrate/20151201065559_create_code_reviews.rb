class CreateCodeReviews < ActiveRecord::Migration
  def change
    create_table :code_reviews do |t|
      t.string :issue_type
      t.string :check_name
      t.text :description
      t.string :engine_name
      t.string :file_path
      t.integer :line_begin
      t.integer :line_end
      t.string :remediation_points
      t.timestamps null: false
    end
  end
end
