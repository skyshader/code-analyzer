class CreateRepoLogs < ActiveRecord::Migration
  def up
    create_table :repo_logs do |t|
      t.string :process_type
      t.string :request_type
      t.integer :success_status, :default => 0
      t.integer :is_error, :default => 0
      t.integer :error_status, :default => 0
      t.text :error_message
      t.references :supplier_project_repo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :repo_logs, column: :supplier_project_repo_id
    drop_table :repo_logs
  end
end
