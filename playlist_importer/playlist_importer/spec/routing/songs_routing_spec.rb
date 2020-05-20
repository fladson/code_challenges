require 'rails_helper'

RSpec.describe SongsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/songs').to route_to('songs#index')
    end
  end
end
