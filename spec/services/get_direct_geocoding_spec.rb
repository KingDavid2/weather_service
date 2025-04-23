require 'rails_helper'

RSpec.describe GetDirectGeocoding do
  describe '.search' do
    context "When call is succesful" do
      let(:city) { "Utah" }
      let(:q) { "#{city}, ,US" }

      before do
        stub_request(:get, "https://api.openweathermap.org/geo/1.0/direct")
          .with(query: {
            q:,
            appid: ENV['OPENWEATHER_API_KEY'],
            limit: '1'
          })
          .to_return(
            status: 200,
            body: [
              {
                name: "Fort Utah",
                lat: 40.23684315,
                lon: -111.70234036058324,
                country: "US",
                state: "Utah"
              }
            ].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns parsed location data for Utah' do
        result = GetDirectGeocoding.search(city:)

        expect(result).to include(
          "name" => "Fort Utah",
          "lat" => 40.23684315,
          "lon" => -111.70234036058324,
          "country" => "US",
          "state" => "Utah"
        )
      end
    end
    context "when the location is not found" do
      before do
        stub_request(:get, "https://api.openweathermap.org/geo/1.0/direct")
          .with(query: {
            q: "InvalidCity, ,US",
            appid: ENV["OPENWEATHER_API_KEY"],
            limit: 1
          })
          .to_return(status: 200, body: "[]", headers: { 'Content-Type' => 'application/json' })
      end

      it "returns a not found error" do
        result = described_class.search(city: "InvalidCity")

        expect(result).to eq({
          error: "Not found",
          code: 404
        })
      end
    end
  end
end
