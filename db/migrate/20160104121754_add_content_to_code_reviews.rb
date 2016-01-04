class AddContentToCodeReviews < ActiveRecord::Migration
  def change
    add_column :code_reviews, :content, :text
  end
end
