class CreateSupportedLanguages < ActiveRecord::Migration
  def change
    create_table :supported_languages do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
