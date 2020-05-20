require 'rails_helper'

describe MovieSerializer do
  subject { JSON.parse(described_class.new(movie).to_json) }

  describe 'as_json' do
    before do
      allow(ArtistInfo::Client).to receive(:artists).and_return([])
    end

    let(:movie) do
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
      }
    end

    it 'returns the correct json' do
      expect(subject['id']).to eq(78)
      expect(subject['title']).to eq('title')
      expect(subject['releaseYear']).to eq(1982)
      expect(subject['revenue']).to eq('US$ 0')
      expect(subject['posterPath']).to eq('https://image.tmdb.org/t/p/w342/5ig0kdWz5kxR4PHjyCgyI5khCzd.jpg')
      expect(subject['genres']).to eq([878,18,53])
      expect(subject['cast']).to eq([])
    end
  end
end
