class CreateBranches < ActiveRecord::Migration
  def up
    create_table :branches do |t|
      t.string :name
      t.integer :is_analyzed, default: 0
      t.integer :is_activity_generated, default: 0
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
