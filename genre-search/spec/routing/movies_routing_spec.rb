require 'rails_helper'

describe Api::V1::MoviesController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/movies').to route_to(controller: 'api/v1/movies', action: 'show', format: :json)
    end
  end
end
