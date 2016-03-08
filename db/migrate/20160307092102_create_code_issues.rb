class CreateCodeIssues < ActiveRecord::Migration
  def up
    create_table :code_issues, id: false do |t|
      t.integer :id
      t.text :file_path
      t.text :issue_text
      t.integer :begin_line
      t.integer :end_line
      t.integer :issue_column
      t.text :source_code
      t.integer :weight
      t.string :engine
      t.string :engine_ruleset
      t.integer :version
      t.integer :status, default: 0
      t.references :branch
      t.references :issue_category
      t.references :file_list

      t.timestamps null: false
    end

    execute(
      "ALTER TABLE code_issues ADD PRIMARY KEY (id, branch_id) PARTITION BY HASH(branch_id) PARTITIONS 11;"
    )

    add_index :code_issues, :branch_id
    add_index :code_issues, :issue_category_id
    add_index :code_issues, :file_list_id

    execute(
      "ALTER TABLE code_issues CHANGE `id` `id` INT UNSIGNED NOT NULL AUTO_INCREMENT"
    )
  end

  def down
    drop_table :code_issues
  end

end
