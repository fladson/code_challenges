class Playlist < ApplicationRecord
  belongs_to :user

  def songs
    @songs ||= Song.where(id: mp3_ids.split(',').map(&:to_i))
  end
end
