class PublicRepositorySearchService
  def self.call(query)
    return unless query.present?
    client = Octokit::Client.new

    client.search_repositories(query, {})
  end
end
