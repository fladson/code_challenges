require 'rails_helper'

describe Api::V1::MoviesController do
  describe 'GET #show' do
    before do
      allow(MoviesFinderService).to receive(:call).and_return([])
      allow(MoviesSerializer).to receive(:from_object).and_return([])
    end

    it 'calls the service and serializer' do
      get :show, params: { genre: 'genre' }

      expect(MoviesFinderService).to have_received(:call)
      expect(MoviesSerializer).to have_received(:from_object)
    end
  end
end
