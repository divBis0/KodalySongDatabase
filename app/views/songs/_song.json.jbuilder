json.extract! song, :id, :title, :data, :comments, :created_at, :updated_at
json.url song_url(song, format: :json)
