class CreateLanguageStats < ActiveRecord::Migration
  def up
    create_table :language_stats do |t|
      t.integer :issues_count
      t.integer :files_count
      t.references :supported_language, index: true, foreign_key: true
      t.references :branch, index: true, foreign_key: true
      t.timestamps null: false
    end
  end

  def down
    remove_foreign_key :language_stats, column: :supported_language_id
    remove_foreign_key :language_stats, column: :branch_id
  end
end
