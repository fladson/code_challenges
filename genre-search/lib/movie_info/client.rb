module MovieInfo
  class Client
    attr_reader :movies_ids

    def initialize(movies_ids)
      @movies_ids = movies_ids
    end

    def self.movies(movies_ids)
      new(movies_ids).movies_by_ids
    end

    # the methods below can be extracted to a concern or to a more general base client

    def movies_by_ids
      max_retries = Constants::NUMBER_OF_RETRIES
      result = []

      # TODO: Parallel requests
      split_params.each do |param|
        response = connection.get('movies', param)
        parsed_response = JSON.parse(response.body)
        result << parsed_response['data'] if (200...299).include?(response.status)
      rescue ApiExceptions::InternalServerError
        next if max_retries.zero? # TODO: Add to errors and do not raise

        # this retry mechanism could be in a Retriable concern
        sleep Constants::RETRY_DELAY_INTERVAL
        max_retries -= 1
        retry
      rescue ApiExceptions::MovieInfoIncompleteError
        result << {
          code: 450,
          message: "Movie id ##{param[:id]} details can not be retrieved"
        }
      end

      result.flatten
    end

    def split_params
      movies_ids.each_with_object([]) do |id, array|
        array << { id: id }
      end
    end

    def connection
      Connection.build(Constants::MOVIE_INFO_API_ENDPOINT)
    end
  end
end
