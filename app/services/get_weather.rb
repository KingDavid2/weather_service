class GetWeather
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5/"

  def self.search(lat:, lon:, units: "imperial")
    with_error_handler do
      get("/weather", query: {
        lat:,
        lon:,
        units:,
        appid: ENV["OPENWEATHER_API_KEY"]
      }
      )
    end
  end

  def self.with_error_handler
    response = yield

    if response["cod"] != 200
      return { error: response["message"] || "API error", code: response["cod"] }
    end

    response
  rescue HTTParty::Error => e
    { error: "HTTParty error: #{e.message}" }
  rescue StandardError => e
    { error: "Unexpected error: #{e.message}" }
  end
end
