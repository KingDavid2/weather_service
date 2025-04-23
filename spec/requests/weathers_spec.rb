require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /" do
    let(:lat) { 40.23684315 }
    let(:lon) { -111.70234036058324 }
    let(:units) { 'imperial' }
    let(:api_key) { ENV['OPENWEATHER_API_KEY'] }

    context "when the call is successful" do
      before do
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather")
          .with(query: {
            lat: lat,
            lon: lon,
            units: units,
            appid: api_key
          })
          .to_return(
            status: 200,
            body: {
              "coord"=> {
                "lat": lat,
                "lon": lon
              },
              "weather" => [ { "main" => "Clear", "description" => "clear sky" } ],
              "main" => {
                "temp" => 66.04,
                "feels_like" => 63.37,
                "temp_min" => 64.92,
                "temp_max" => 67.06
              },
              "cod" => 200
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "renders temperature in the response body" do
        get root_path, params: { lat: lat, lon: lon }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Your current location is lat: 40.23684315, lon: -111.70234036058324")
        expect(response.body).to include("Temperature: 66.04°F")
        expect(response.body).to include("Feels like: 63.37°F")
        expect(response.body).to include("Max: 67.06°F")
        expect(response.body).to include("Min: 64.92°F")
      end
    end

    context "when the coordinates are invalid" do
      let(:bad_lon) { 12345 }

      before do
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather")
          .with(query: {
            lat: lat,
            lon: bad_lon,
            units: units,
            appid: api_key
          })
          .to_return(
            status: 404,
            body: {
              "cod" => "404",
              "message" => "wrong longitude"
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "shows an error message in the response body" do
        get root_path, params: { lat: lat, lon: bad_lon }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("wrong longitude")
      end
    end
  end
end
