Octokit.configure do |config|
  config.client_id = ENV['GITHUB_CLIENT_ID']
  config.client_secret = ENV['GITHUB_CLIENT_SECRET']
  config.per_page = ENV['RESULTS_PER_PAGE']
end
