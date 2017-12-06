class CreateConcepts < ActiveRecord::Migration[5.0]
  def change
    create_table :concepts do |t|
      t.references :song, foreign_key: true
      t.string :name
      t.boolean :rhythm
      t.boolean :prepare
      t.boolean :present
      t.boolean :practice

      t.timestamps
    end
  end
end
