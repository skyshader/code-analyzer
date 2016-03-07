class CreateIssueCategories < ActiveRecord::Migration
  def change
    create_table :issue_categories do |t|
      t.string :name
      t.text :description
      t.integer :status, default: 1

      t.timestamps null: false
    end
  end
end
