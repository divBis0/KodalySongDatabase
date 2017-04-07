class RemoveDataFromSongs < ActiveRecord::Migration[5.0]
  def change
    remove_column :songs, :data, :hstore, index: true
  end
end
