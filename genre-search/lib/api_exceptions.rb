module ApiExceptions
  class InternalServerError < RuntimeError; end
  class ArtistInfoIncompleteError < RuntimeError; end
  class MovieInfoIncompleteError < RuntimeError; end
end
