require 'rails_helper'

describe MovieSearch::Client do
  describe '.movies_by_genre' do
    let(:subject) { described_class.movies_by_genre(params) }

    context 'when successfull request' do
      let(:params) { { genre: 'Drama', offset: 0, limit: 10 } }

      it 'returns only the desired data' do
        VCR.use_cassette 'movie_search_ok' do
          expect(subject.count).to eq(10)
        end
      end
    end

    context 'when downstream is unavailable' do
      let(:params) { { genre: 'Drama', offset: 0, limit: 10 } }
      let(:number_of_retries) { 2 }

      before do
        stub_const('Constants::NUMBER_OF_RETRIES', number_of_retries)
        described_class.stub(:sleep)
      end

      it 'retries the defined amount of times' do
        VCR.use_cassette 'movie_search_unavailable', allow_playback_repeats: true do
          expect { subject }.to raise_error(ApiExceptions::InternalServerError)
          expect(described_class).to have_received(:sleep).exactly(number_of_retries).times
        end
      end
    end
  end
end
