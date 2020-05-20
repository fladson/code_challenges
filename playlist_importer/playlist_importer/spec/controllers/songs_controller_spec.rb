require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      assert_response :success
    end

    it 'also returns a json' do
      get :index, as: :json
      assert_response :success
    end
  end
end
