require 'rails_helper'

describe ArtistInfo::Client do
  let(:client) { described_class.new(artists_ids) }

  describe '#artists_by_ids' do
    let(:artists_ids) { [3] }
    let(:subject) { client.artists_by_ids }

    context 'when successfull request' do
      it 'returns only the desired data' do
        VCR.use_cassette 'artist_info_ok' do
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
        VCR.use_cassette 'artist_info_unavailable', allow_playback_repeats: true do
          subject
          expect(client).to have_received(:sleep).exactly(number_of_retries).times
        end
      end

      context 'when downstream is returning 440' do
        it 'returns the correct error information' do
          VCR.use_cassette 'artist_info_error', allow_playback_repeats: true do
            expect(subject.first[:code]).to eq(440)
          end
        end
      end
    end
  end

  describe '#split_params' do
    let(:subject) { client.split_params }

    context 'when movies_ids has more than 1 id' do
      let(:artists_ids) { (1..6).to_a }

      it 'returns an array with the params splited' do
        expect(subject.count).to eq(artists_ids.count)
      end

      it 'returns an array with the correct params' do
        expect(subject.first).to eq(id: artists_ids.first)
        expect(subject.last).to eq(id: artists_ids.last)
      end
    end
  end
end
