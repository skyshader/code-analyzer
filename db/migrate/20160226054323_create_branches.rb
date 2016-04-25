class CreateBranches < ActiveRecord::Migration
  def up
    create_table :branches do |t|
      t.string :name
      t.integer :current_version, default: 0
      t.float :grade
      t.string :gpa
      t.integer :status, default: 1
      t.references :repository, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :branches, column: :repository_id
    drop_table :branches
  end
end
