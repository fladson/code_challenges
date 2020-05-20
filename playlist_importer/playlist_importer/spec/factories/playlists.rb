FactoryGirl.define do
  factory :playlist do
    user { create :user }
    name 'Offline'
    mp3_ids '1,2,3'
  end
end
