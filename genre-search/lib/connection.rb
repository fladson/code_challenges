class Connection
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def self.build(url)
    new(url).connection
  end

  def connection
    @connection ||= Faraday.new(url: @url) do |req|
      req.use ErrorHandling
      req.headers['Content-Type'] = 'application/json'
      req.adapter Faraday.default_adapter
    end
  end
end
