class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :username
      t.string :owner
      t.string :name
      t.string :ssh_url
      t.text :directory
      t.string :default_branch
      t.string :current_branch
      t.integer :is_private
      t.integer :project_id, null: false
      t.integer :status

      t.timestamps null: false
    end
  end
end
