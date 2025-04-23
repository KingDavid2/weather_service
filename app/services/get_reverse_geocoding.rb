class GetReverseGeocoding
  include HTTParty
  include HttpErrorHandler
  base_uri "https://api.openweathermap.org/geo/1.0"

  def self.search(lat:, lon:)
    with_error_handler do
      get("/reverse", query: {
        lat:,
        lon:,
        appid: ENV["OPENWEATHER_API_KEY"],
        limit: 1
      }).parsed_response
    end
  end
end
