require 'rails_helper'

RSpec.describe FileImporterController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #import' do
    file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/files/user_data.csv'))
    it 'redirects to model path' do
      post :import, params: { file: file }

      assert_redirected_to users_path
    end

    it 'render new when database has data with ids taken' do
      create :user
      post :import, params: { file: file }

      assert_equal 'File contains data already imported. Try again with a different set of data.', flash[:error]
    end
  end
end
