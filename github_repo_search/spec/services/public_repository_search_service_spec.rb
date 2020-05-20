require 'rails_helper'

RSpec.describe PublicRepositorySearchService do
  describe '.call' do
    subject(:result) { described_class.call(query) }

    context 'when query is present' do
      let(:query) { 'foo' }

      it 'returns the expected result' do
        VCR.use_cassette('successful_search_repositories') do
          expect(result.total_count).not_to be_blank
        end
      end
    end

    context 'when query is blank' do
      let(:query) { '' }

      before do
        allow(Octokit::Client).to receive(:new)
      end

      it 'does not call Octokit::Client.new' do
        subject

        expect(Octokit::Client).not_to have_received(:new)
      end
    end
  end
end
