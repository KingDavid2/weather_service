require 'rails_helper'

RSpec.describe Weather, type: :model do
  describe '.search' do
    let(:lat) { 40.23684315 }
    let(:lon) { -111.70234036058324 }
    let(:fake_weather_response) do
      {
        "weather" => [ { "main" => "Clear", "description" => "clear sky" } ],
        "main" => { "temp" => 70.0 },
        "coord" => { "lat" => lat, "lon" => lon }
      }
    end

    let(:fake_location_response) do
      {
        "name"=>"Provo",
        "lat"=>lat,
        "lon"=>lon,
        "country"=>"US",
        "state"=>"Utah"
      }
    end

    context 'when a recent weather record exists' do
      let!(:existing_weather) do
        Weather.create!(
          lat: lat,
          lon: lon,
          city: 'Provo',
          state: 'Utah',
          data: fake_weather_response,
          fetched_at: 30.minutes.ago
        )
      end

      it 'returns the cached record without calling the API' do
        expect(GetWeather).not_to receive(:search)

        result = Weather.search(lat: lat, lon: lon)

        expect(result).to eq(existing_weather)
      end
    end

    context 'when no recent record exists' do
      before do
        allow(GetWeather).to receive(:search).with(lat: lat, lon: lon).and_return(fake_weather_response)
        allow(GetReverseGeocoding).to receive(:search).with(lat: lat, lon: lon).and_return(fake_location_response)
      end

      let!(:old_weather) do
        Weather.create!(
          lat: lat,
          lon: lon,
          city: 'Provo',
          state: 'Utah',
          data: fake_weather_response,
          fetched_at: 2.hours.ago
        )
      end

      it 'calls the API and creates a new record' do
        expect {
          result = Weather.search(lat: lat, lon: lon)

          expect(result.lat).to eq(lat)
          expect(result.lon).to eq(lon)
          expect(result.data['main']['temp']).to eq(70.0)
        }.to change { Weather.count }.by(1)
      end
    end
  end

  describe '.recent' do
    let!(:recent_weather) do
      Weather.create!(
        lat: 40.0,
        lon: -111.0,
        data: { "main" => { "temp" => 72.0 } },
        fetched_at: 30.minutes.ago
      )
    end

    let!(:old_weather) do
      Weather.create!(
        lat: 41.0,
        lon: -112.0,
        data: { "main" => { "temp" => 65.0 } },
        fetched_at: 2.hours.ago
      )
    end

    it 'returns only records fetched within the past hour' do
      result = Weather.recent

      expect(result).to include(recent_weather)
      expect(result).not_to include(old_weather)
    end
  end

  describe "#image_url" do
    it "returns the correct OpenWeatherMap icon URL" do
      weather = described_class.new(
        data: {
          "weather" => [
            { "icon" => "04d" }
          ]
        }
      )

      expect(weather.image_url).to eq("https://openweathermap.org/img/wn/04d@2x.png")
    end
  end
end
