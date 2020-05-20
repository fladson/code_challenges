require 'rails_helper'

describe MovieInfo::Client do
  let(:client) { described_class.new(movies_ids) }

  describe '#movies_by_ids' do
    let(:movies_ids) { [78] }
    let(:subject) { client.movies_by_ids }

    context 'when successfull request' do
      it 'returns only the desired data' do
        VCR.use_cassette 'movie_info_ok' do
          expect(subject.count).to eq(1)
        end
      end
    end

    context 'when downstream is unavailable' do
      let(:number_of_retries) { 2 }

      before do
        stub_const('Constants::NUMBER_OF_RETRIES', number_of_retries)
        client.stub(:sleep)
      end

      it 'retries the defined amount of times' do
        VCR.use_cassette 'movie_info_unavailable', allow_playback_repeats: true do
          subject
          expect(client).to have_received(:sleep).exactly(number_of_retries).times
        end
      end
    end

    context 'when downstream is returning 450' do
      it 'returns the correct error information' do
        VCR.use_cassette 'movie_info_error', allow_playback_repeats: true do
          expect(subject.first[:code]).to eq(450)
        end
      end
    end
  end

  describe '#split_params' do
    let(:subject) { client.split_params }

    context 'when movies_ids has more than 1 id' do
      let(:movies_ids) { (1..6).to_a }

      it 'returns an array with the params splited' do
        expect(subject.count).to eq(movies_ids.count)
      end

      it 'returns an array with the correct params' do
        expect(subject.first).to eq(id: movies_ids.first)
        expect(subject.last).to eq(id: movies_ids.last)
      end
    end
  end
end
