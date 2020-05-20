require 'rails_helper'

describe Connection do
  let(:url) { 'http://foo.com.br' }
  let(:connection) { described_class.build(url) }

  describe '.build' do
    it 'returns a connection with the given url as host' do
      expect(url).to include(connection.host)
    end

    it 'returns a json content type connection' do
      expect(connection.headers['Content-type']).to eq('application/json')
    end
  end
end
