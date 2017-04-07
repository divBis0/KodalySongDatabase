class CreateFieldCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :field_categories do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
