class CreateCodeReviewCategories < ActiveRecord::Migration
  def up
    create_table :code_review_categories do |t|
      t.string :name
      t.references :code_category, index: true, foreign_key: true
      t.references :code_review, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
  	remove_foreign_key :code_review_categories, column: :code_category_id
  	remove_foreign_key :code_review_categories, column: :code_review_id
  	drop_table :code_review_categories
  end
end
