class AddImageIdToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :image_id, :string
  end
end
