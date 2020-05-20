require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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

  describe 'GET #show' do
    let(:user) { create(:user) }

    it 'returns a success response' do
      get :show, params: { id: user.to_param }
      assert_response :success
    end

    it 'also returns a json' do
      get :show, as: :json, params: { id: user.to_param }
      assert_response :success
    end

    it 'returns a not_found response' do
      get :show, params: { id: 0 }
      assert_response :not_found
    end
  end
end
