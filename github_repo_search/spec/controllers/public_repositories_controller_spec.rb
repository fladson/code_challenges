require 'rails_helper'

RSpec.describe PublicRepositoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #search' do
    let(:query) { 'foo' }

    it 'calls the search service with the correct params' do
      allow(PublicRepositorySearchService).to receive(:call)
      post :search, params: { query: query }

      expect(PublicRepositorySearchService).to have_received(:call).with(query)
    end
  end
end
