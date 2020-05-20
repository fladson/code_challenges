require 'rails_helper'
RSpec.describe FileImportService do
  file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/files/user_data.csv'))

  describe '.import' do
    subject { described_class.import(file) }
    context 'database is empty' do
      it 'parse the file and create new entries' do
        expect{ subject }.to change{ User.count }.from(0).to(2)
        expect(User.first.first_name).to eq('Susan')
        expect(User.first.user_name).to eq('sgomez0')
      end
    end

    context 'database is not empty' do
      it 'parse the file and does not create new entries' do
        create :user
        expect{ subject }.to raise_error(ActiveRecord::RecordNotUnique)
        expect(User.count).to eq(1)
      end
    end
  end

  describe '.import_type' do
    it 'returns User for the user_data.csv' do
      described_class.import(file)
      expect(described_class.import_type).to eq('User')
    end
  end
end
