require 'rails_helper'

describe CastSerializer do
  subject { JSON.parse(described_class.new(cast).to_json) }

  describe 'as_json' do
    let(:cast) do
      {
        'id' => 78,
        'gender' => 1,
        'name' => 'name',
        'profilePath' => 'foo'
      }
    end

    it 'returns the correct json' do
      expect(subject['id']).to eq(78)
      expect(subject['gender']).to eq('Female')
      expect(subject['name']).to eq('name')
      expect(subject['profilePath']).to eq('foo')
    end
  end
end
