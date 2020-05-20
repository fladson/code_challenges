require 'rails_helper'

describe MoviesFinderService do
  describe '.call' do
    subject { described_class.call('params') }

    before do
      allow(MovieSearch::Client).to receive(:movies_by_genre)
      allow(MovieInfo::Client).to receive(:movies)
    end

    it 'will call the correct clients' do
      subject
      expect(MovieSearch::Client).to have_received(:movies_by_genre)
      expect(MovieInfo::Client).to have_received(:movies)
    end
  end
end
