class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :songs do |t|
      t.string :title
      t.hstore :data
      t.string :comments

      t.timestamps
    end
    add_index :songs, :data, using: :gin
  end
end
