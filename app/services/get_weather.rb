class GetWeather
  include HTTParty
  include HttpErrorHandler
  base_uri "https://api.openweathermap.org/data/2.5/"

  def self.search(lat:, lon:, units: "imperial")
    with_error_handler do
      get("/weather", query: {
        lat:,
        lon:,
        units:,
        appid: ENV["OPENWEATHER_API_KEY"]
      }).parsed_response
    end
  end
end
