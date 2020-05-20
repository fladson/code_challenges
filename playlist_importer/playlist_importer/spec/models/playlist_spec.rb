require 'rails_helper'

RSpec.describe 'Playlist', type: :model do
  describe '#songs' do
    it 'returns the correct songs as active records' do
      songs = create_list(:song, 2)
      playlist = create :playlist, mp3_ids: songs.map(&:id).join(',').to_s

      expect(playlist.songs).to eq(songs)
    end
  end
end
