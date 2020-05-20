require 'csv'

class FileImportService
  attr_reader :file

  def self.import(file)
    @file = file
    parse_file
  end

  def self.import_type
    headers = CSV.read(@file.path, headers: true).headers

    return 'Song'      if headers.include? 'Title'
    return 'User'      if headers.include? 'first_name'
    return 'Playlist'  if headers.include? 'mp3_ids'
  end

  class << self
    def parse_file
      model = import_type
      records = []
      CSV.foreach(@file.path, headers: true, header_converters: :downcase) do |row|
        records << model.constantize.new(row.to_h.reject { |k| k.blank? })
      end
      ActiveRecord::Base.transaction do
        model.constantize.import(records)
      end
    end
  end
end
