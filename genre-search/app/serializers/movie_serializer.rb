class MovieSerializer < ApplicationSerializer
  include ActionView::Helpers::NumberHelper

  def as_json(*)
    {
      id: object['id'],
      title: object['title'],
      releaseYear: releaseYear,
      revenue: revenue,
      posterPath: object['posterPath'],
      genres: object['genres'], # TODO: convert ids to names
      cast: cast
    }
  end

  private

  def releaseYear
    Date.parse(object['releaseDate']).year
  end

  def revenue
    number_to_currency(object['revenue'], unit: 'US$ ', precision: 0)
  end

  def cast
    artists_info = ArtistInfo::Client.artists(object['cast'])
    CastSerializer.from_collection(artists_info)
  end
end
