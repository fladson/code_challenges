class PublicRepositoriesController < ApplicationController
  def index
  end

  def search
    @query = search_params[:query]
    @result = PublicRepositorySearchService.call(@query)
  end

  private

  def search_params
    params.permit(:query)
  end
end
