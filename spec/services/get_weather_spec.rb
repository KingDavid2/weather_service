require 'rails_helper'

RSpec.describe GetWeather do
  describe ".search" do
    let(:lat) { 40.23684315 }
    let(:lon) { -111.70234036058324 }
    let(:units) { 'imperial' }
    let(:api_key) { ENV['OPENWEATHER_API_KEY'] }

    context "When call is succesful" do
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
                  "lon": lon,
                  "lat": lat
              },
              "weather" => [ { "main" => "Clear", "description" => "clear sky" } ],
              "main" => { "temp"=>66.04,
                          "feels_like"=>63.37,
                          "temp_min"=>64.92,
                          "temp_max"=>67.06
                        },
              "cod": 200
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "returns parsed weather data" do
        result = described_class.search(lat: lat, lon: lon, units: units)

        expect(result["coord"]["lat"]).to eq(40.23684315)
        expect(result["coord"]["lon"]).to eq(-111.70234036058324)
        expect(result["weather"].first["main"]).to eq("Clear")
        expect(result["weather"].first["description"]).to eq("clear sky")
        expect(result["main"]["temp"]).to eq(66.04)
        expect(result["main"]["feels_like"]).to eq(63.37)
        expect(result["main"]["temp_min"]).to eq(64.92)
        expect(result["main"]["temp_max"]).to eq(67.06)
      end
    end

    context "when API returns an error code" do
      let(:lon) { 12345 }

      before do
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather")
          .with(query: {
            lat: lat,
            lon: lon,
            units: units,
            appid: api_key
          })
          .to_return(
            status: 400,
            body: {
              "cod" => 400,
              "message" => "wrong longitude"
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "returns an error hash with code and message" do
        result = described_class.search(lat: lat, lon: lon, units: units)
        expect(result).to include(error: "wrong longitude", code: 400)
      end
    end

    context "when HTTParty raises an exception" do
      before do
        allow(GetWeather).to receive(:get).and_raise(HTTParty::Error.new("timeout"))
      end

      it "returns an HTTParty error hash" do
        result = described_class.search(lat: lat, lon: lon)
        expect(result[:error]).to include("HTTParty error: timeout")
      end
    end

    context "when a generic error is raised" do
      before do
        allow(GetWeather).to receive(:get).and_raise(StandardError.new("something broke"))
      end

      it "returns a generic error hash" do
        result = described_class.search(lat: lat, lon: lon)
        expect(result[:error]).to include("Unexpected error: something broke")
      end
    end
  end
end
