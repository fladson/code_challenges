class ApplicationSerializer
  def self.from_collection(collection)
    collection.map { |item| new(item) }.as_json
  end

  def self.from_object(object)
    new(object).as_json
  end

  def initialize(object)
    @object = object
  end

  def as_json(*)
    raise NoMethodError, 'You must implement this method'
  end

  def to_json(*)
    as_json.to_json
  end

  protected
  attr_reader :object
end
