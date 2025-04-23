class GetLocation
  include HTTParty
  include HttpErrorHandler
  base_uri "https://api.openweathermap.org/geo/1.0"

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

  def self.handle_attributes(city:, state:, country:)
    city = city.empty? ? " " : city
    state = state.empty? ? " " : state
    country = country.empty? ? "US" : country

    [ city, state, country ].compact.join(",")
  end
end
