class AddAdditionalImagesToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :image2_id, :string
    add_column :songs, :image2_path, :string
    add_column :songs, :image3_id, :string
    add_column :songs, :image3_path, :string
    add_column :songs, :image4_id, :string
    add_column :songs, :image4_path, :string
  end
end
