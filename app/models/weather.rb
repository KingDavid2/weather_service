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

  def image_url
    base_url = "https://openweathermap.org/img/wn/"
    icon = data&.dig("weather", 0, "icon")
    return nil unless icon

    "#{base_url}#{icon}@2x.png"
  end
end
