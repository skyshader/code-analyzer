class CreateFileLists < ActiveRecord::Migration
  def up
    create_table :file_lists do |t|
      t.string :name
      t.integer :is_file
      t.string :extension
      t.integer :file_size
      t.string :phash
      t.string :fhash
      t.string :relative_path
      t.string :parent_path
      t.text :full_path
      t.integer :lines_blank
      t.integer :lines_comment
      t.integer :lines_code
      t.float  :grade
      t.string :gpa
      t.integer :is_excluded, default: 0
      t.integer :status, default: 1

      t.references :branch, index: true, foreign_key: true
      t.references :supported_language, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :file_lists, column: :branch_id
    remove_foreign_key :file_lists, column: :supported_language_id
    drop_table :file_lists
  end
end
