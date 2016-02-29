class CreateRequestLogs < ActiveRecord::Migration
  def up
    create_table :request_logs do |t|
      t.string :process_type
      t.string :request_type
      t.integer :success_status, :default => 0
      t.integer :is_error, :default => 0
      t.integer :error_status, :default => 0
      t.text :error_message
      t.references :branch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :request_logs, column: :branch_id
    drop_table :request_logs
  end
end
