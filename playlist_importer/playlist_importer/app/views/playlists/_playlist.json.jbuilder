json.extract! playlist, :id, :user_id, :name, :mp3_ids, :created_at, :updated_at
json.url playlist_url(playlist, format: :json)
