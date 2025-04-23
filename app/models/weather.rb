class Weather < ApplicationRecord
  scope :recent, -> { where("fetched_at > ?", 1.hour.ago) }

  def self.search(lat:, lon:)
    cached = recent.find_by(lat: lat, lon: lon)
    return cached if cached

    response = GetWeather.search(lat: lat, lon: lon)
    create!(
      lat: lat,
      lon: lon,
      data: response,
      fetched_at: Time.current
    )
  end
end
