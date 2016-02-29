class CreateContributors < ActiveRecord::Migration
  def up
    create_table :contributors do |t|
      t.string :name
      t.string :email
      t.integer :additions
      t.integer :deletions
      t.integer :commits
      t.references :branch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :contributors, column: :branch_id
    drop_table :contributors
  end
end
