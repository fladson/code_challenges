module MovieSearch
  class Client
    def self.movies_by_genre(params)
      max_retries = Constants::NUMBER_OF_RETRIES
      begin
        response = connection.get('movies', params)
        parsed_response = JSON.parse(response.body)
        parsed_response['data'] if (200...299).include?(response.status)
      rescue ApiExceptions::InternalServerError
        raise if max_retries.zero?

        sleep Constants::RETRY_DELAY_INTERVAL
        max_retries -= 1
        retry
      end
    end

    private

    def self.connection
      Connection.build(Constants::MOVIE_SEARCH_API_ENDPOINT)
    end
  end
end
