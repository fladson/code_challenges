# the same comments on MovieInfo::Client applies here
# both classes ended up very similar
module ArtistInfo
  class Client
    attr_reader :artists_ids

    def initialize(artists_ids)
      @artists_ids = artists_ids
    end

    def self.artists(artists_ids)
      new(artists_ids).artists_by_ids
    end

    def artists_by_ids
      max_retries = Constants::NUMBER_OF_RETRIES
      result = []

      split_params.each do |param|
        response = connection.get('artists', param)
        parsed_response = JSON.parse(response.body)
        result << parsed_response['data'] if (200...299).include?(response.status)
      rescue ApiExceptions::InternalServerError
        next if max_retries.zero?

        sleep Constants::RETRY_DELAY_INTERVAL
        max_retries -= 1
        retry
      rescue ApiExceptions::ArtistInfoIncompleteError
        result << {
          code: 440,
          message: "Movie id ##{param[:id]} cast info is not complete"
        }
      end

      result.flatten
    end

    def split_params
      artists_ids.each_with_object([]) do |id, array|
        array << { id: id }
      end
    end

    def connection
      Connection.build(Constants::ARTIST_INFO_API_ENDPOINT)
    end
  end
end
