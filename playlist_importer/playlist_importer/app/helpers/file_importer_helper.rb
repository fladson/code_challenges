module FileImporterHelper
  def empty_data?
    users_count.zero? && playlists_count.zero? && songs_count.zero?
  end

  def users_count
    @user_count ||= User.count
  end

  def playlists_count
    @playlist_count ||= Playlist.count
  end

  def songs_count
    @song_count ||= Song.count
  end
end
