class CreateLanguageStats < ActiveRecord::Migration
  def change
    create_table :language_stats do |t|
      t.integer :issue_count
      t.integer :file_count
      t.references :supported_language

      t.timestamps null: false
    end
  end
end
