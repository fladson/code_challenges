module Api::V1
  class MoviesController < ApplicationController
    def show
      param! :genre, String, in: Constants::ALLOWED_GENRES, required: true
      param! :offset, Integer, default: 0, min: 0
      param! :limit, Integer, default: 10, max: 10

      movies_data = MoviesFinderService.call(movie_params)
      serialized_data = MoviesSerializer.from_object(movies_data)

      render json: serialized_data, status: :ok
    end

    private

    def movie_params
      params.permit(:genre, :offset, :limit)
    end
  end
end
