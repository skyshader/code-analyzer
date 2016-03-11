class CreateRequestLogs < ActiveRecord::Migration
  def up
    create_table :request_logs do |t|
      t.string :request_type
      t.integer :is_waiting, default: 0
      t.integer :is_active, default: 0
      t.integer :is_complete, default: 0
      t.integer :is_error, default: 0
      t.text :error_message
      t.text :error_trace
      t.references :branch, index: true, foreign_key: true
      t.references :repository, index: true, foreign_key: true

      t.integer :status, default: 1

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :request_logs, column: :branch_id
    remove_foreign_key :request_logs, column: :repository_id
    drop_table :request_logs
  end
end
