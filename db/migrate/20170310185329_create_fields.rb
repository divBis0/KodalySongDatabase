class CreateFields < ActiveRecord::Migration[5.0]
  def change
    create_table :fields do |t|
      t.string :name
      t.integer :display_type
      t.integer :field_category_id

      t.timestamps
    end
    
    add_index :fields, :field_category_id
  end
end
