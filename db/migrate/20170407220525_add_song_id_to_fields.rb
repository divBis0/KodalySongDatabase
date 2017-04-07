class AddSongIdToFields < ActiveRecord::Migration[5.0]
  def change
    add_column :fields, :song_id, :integer
    add_index :fields, :song_id
  end
end
