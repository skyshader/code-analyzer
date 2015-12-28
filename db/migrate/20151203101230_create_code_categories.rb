class CreateCodeCategories < ActiveRecord::Migration
  def change
    create_table :code_categories do |t|
      t.string :name
      t.integer :weight
      t.timestamps null: false
    end
  end
end
