class AddImagePathToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :image_path, :string
  end
end
