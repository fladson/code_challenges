class FileImporterController < ApplicationController
  def new
  end

  def import
    FileImportService.import(params[:file])
    redirect_to model_paths(FileImportService.import_type)
  rescue ActiveRecord::RecordNotUnique
    flash[:error] = 'File contains data already imported. Try again with a different set of data.'
    render :new
  end

  private

  def file_params
    params.require(:file)
  end

  def model_paths(model)
    case model
    when 'User'
      users_url
    when 'Song'
      songs_url
    when 'Playlist'
      playlists_url
    end
  end
end
