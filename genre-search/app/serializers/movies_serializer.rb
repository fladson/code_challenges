class MoviesSerializer < ApplicationSerializer
  def as_json(*)
    {
      data: {
        movies: movies
      },
      metada: {
        offset: nil, # TODO
        limit: nil, # TODO
        total: object.count
      },
      errors: [] # TODO
    }
  end

  private

  def movies
    MovieSerializer.from_collection(object)
  end
end
