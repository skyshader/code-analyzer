class AddDescriptionToCodeCategories < ActiveRecord::Migration
  def change
    add_column :code_categories, :description, :text
  end
end
