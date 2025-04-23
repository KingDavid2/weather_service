class GetLocation
  include HTTParty
  base_uri "http://api.openweathermap.org/geo/1.0"

  def self.search(city: " ", state: " ", country: "US")
    query_string = handle_attributes(city: city, state: state, country: country)

    with_error_handler do
      get("/direct", query: {
        q: query_string,
        appid: ENV["OPENWEATHER_API_KEY"],
        limit: 1
      }).parsed_response
    end
  end

  def self.with_error_handler
    response = yield

    if response.is_a?(Hash) && response["cod"] != 200
      return { error: response["message"].capitalize || "API error", code: response["cod"] }
    elsif response.is_a?(Array) && response.empty?
      return { error: "Not found", code: 404 }
    end

    response.first
  rescue HTTParty::Error => e
    { error: "HTTParty error: #{e.message}" }
  rescue StandardError => e
    { error: "Unexpected error: #{e.message}" }
  end

  def self.handle_attributes(city:, state:, country:)
    city = city.empty? ? " " : city
    state = state.empty? ? " " : state
    country = country.empty? ? "US" : country

    [ city, state, country ].compact.join(",")
  end
end
