class MoviesFinderService
  def self.call(params)
    movies_ids = MovieSearch::Client.movies_by_genre(params)
    MovieInfo::Client.movies(movies_ids)
  end
end
