require 'rails_helper'

describe 'Movies API', type: :request do
  describe 'GET /api/v1/movies' do
    subject { get '/api/v1/movies', params: params }
    before { subject }

    context 'when valid params' do
      let(:params) { { genre: 'genre' } }

      it 'responds with a success response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when missing required params' do
      let(:params) {}

      it 'responds with a unprocessable_entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with the correct message' do
        expect(json[:message]).to eq('Parameter genre is required')
      end
    end

    context 'when invalid genre value' do
      let(:params) { { genre: 'invalid' } }

      it 'responds with a unprocessable_entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with the correct message' do
        expect(json[:message]).to start_with('Parameter genre must be within')
      end
    end
  end
end
