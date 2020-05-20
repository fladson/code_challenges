require 'faraday'

class ErrorHandling < Faraday::Response::Middleware
  def on_complete(env)
    case env[:status]
    when 500..510
      raise ApiExceptions::InternalServerError, 'Downstream service is unavailable'
    when 440
      raise ApiExceptions::ArtistInfoIncompleteError, 'Cast info is not complete'
    when 450
      raise ApiExceptions::MovieInfoIncompleteError, 'Movie info is not complete'
    end
  end
end
