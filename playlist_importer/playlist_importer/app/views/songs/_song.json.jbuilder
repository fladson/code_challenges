json.extract! song, :id, :title, :interpret, :album, :track, :year, :genre, :created_at, :updated_at
json.url song_url(song, format: :json)
