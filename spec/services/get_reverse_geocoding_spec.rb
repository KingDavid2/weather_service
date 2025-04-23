require 'rails_helper'

RSpec.describe GetReverseGeocoding do
  describe ".search" do
    let(:lat) { 40.7815739 }
    let(:lon) { -111.9735801 }
    let(:api_key) { ENV["OPENWEATHER_API_KEY"] }

    before do
      stub_request(:get, "https://api.openweathermap.org/geo/1.0/reverse")
        .with(query: {
          lat: lat,
          lon: lon,
          appid: api_key,
          limit: 1
        })
        .to_return(
          status: 200,
          body: [
            {
              "name" => "Salt Lake City",
              "lat" => lat,
              "lon" => lon,
              "state" => "Utah",
              "country" => "US"
            }
          ].to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it "returns parsed reverse geocoding data" do
      result = described_class.search(lat: lat, lon: lon)

      expect(result).to be_a(Hash)
      expect(result).to include(
        "name" => "Salt Lake City",
        "lat" => lat,
        "lon" => lon,
        "state" => "Utah",
        "country" => "US"
      )
    end
  end
end
