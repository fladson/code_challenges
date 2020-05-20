require 'rails_helper'

describe MoviesSerializer do
  subject { JSON.parse(described_class.new(movies).to_json) }

  describe 'as_json' do
    before do
      allow(ArtistInfo::Client).to receive(:artists).and_return([])
    end

    let(:movies) do
      [
        {
          'id' => 78,
          'title' => 'title',
          'overview' => 'overview',
          'popularity' => 22.541746,
          'runtime' => 117,
          'releaseDate' => '1982-06-25',
          'revenue' => 0,
          'budget' => 10000000,
          'posterPath' => 'https://image.tmdb.org/t/p/w342/5ig0kdWz5kxR4PHjyCgyI5khCzd.jpg',
          'originalLanguage' => 'en',
          'genres' => [878,18,53],
          'cast' => [3,585,586,587,588,589,590]
        },
        {
          'id' => 79,
          'title' => 'title 2',
          'overview' => 'overview 2',
          'popularity' => 22,
          'runtime' => 115,
          'releaseDate' => '1991-06-25',
          'revenue' => 0,
          'budget' => 10000000,
          'posterPath' => 'https://image.tmdb.org/t/p/w342/5ig0kdWz5kxR4PHjyCgyI5khCzd.jpg',
          'originalLanguage' => 'en',
          'genres' => [878,18,53],
          'cast' => [3,585,586,587,588,589,590]
        }
      ]
    end

    it 'returns the correct json' do
      expect(subject['data']['movies'].count).to eq(2)
      expect(subject['metada']['total']).to eq(2)
      expect(subject['errors']).to eq([])
    end
  end
end
