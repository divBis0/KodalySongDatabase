class AddFieldDatums < ActiveRecord::Migration[5.0]
  def change
    remove_column :fields, :data, :string
    remove_column :fields, :song_id, :integer, index: true
    
    create_table :field_datums do |t|
      t.string :data
      t.integer :song_id
      t.integer :field_id

      t.timestamps
    end
    
    add_index :field_datums, :field_id
    add_index :field_datums, :song_id
  end
end
