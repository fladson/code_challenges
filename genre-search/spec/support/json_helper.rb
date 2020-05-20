module JsonHelper
  def json
    (reparse_and_never_memoize_as_response_may_change = -> do
      JSON.parse(response.body, symbolize_names: true)
    end).call
  end
end
