require 'rails_helper'

RSpec.describe PlaylistsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/playlists').to route_to('playlists#index')
    end

    it 'routes to #show' do
      expect(get: '/playlists/1').to route_to('playlists#show', id: '1')
    end
  end
end
