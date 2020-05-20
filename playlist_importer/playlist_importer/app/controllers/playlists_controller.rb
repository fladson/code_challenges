class PlaylistsController < ApplicationController
  before_action :set_playlist, only: :show

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = Playlist.all.includes(:user)
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:id])
  end
end
