class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.string :city
      t.integer :copyright_year
      t.string :web_site
      t.integer :user_id

      t.timestamps
    end
    add_column :songs, :source_id, :integer
  end
end
