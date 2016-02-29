class CreateFileLists < ActiveRecord::Migration
  def up
    create_table :file_lists do |t|
      t.string :name
      t.text :path
      t.string :extension
      t.integer :is_file
      t.integer :is_excluded, default: 0
      t.integer :parent, default: 0
      t.string :fhash
      t.string :phash

      t.references :branch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :file_lists, column: :branch_id
    drop_table :file_lists
  end
end
