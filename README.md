# 🌦️ Weather Service

A lightweight Ruby on Rails application that displays real-time weather data based on either the user's geolocation or a searched city/state.
It integrates with the OpenWeatherMap API and features a modern, responsive UI using TailwindCSS and Turbo.

---

## 🚀 Features

- 📍 Auto-fetch weather from user's current location using browser geolocation
- 🔍 Search by city and/or state using OpenWeatherMap's geocoding service
- 🌤️ Displays temperature, weather condition, min/max/feels-like temperatures, and icon
- 🌈 Responsive UI styled with TailwindCSS

---

## 🛠️ Tech Stack

- **Backend:** Ruby on Rails 8
- **Frontend:** TailwindCSS + Turbo
- **API Integration:** [OpenWeatherMap](https://openweathermap.org/api)

---

## 📦 Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/KingDavid2/weather_service.git
cd weather_service
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up environment variables

Create a .env file or use credentials.yml.enc with the following key:

```bash
OPENWEATHER_API_KEY=your_api_key_here
```

You can get an API key from OpenWeatherMap.

### 4. Run the server

```bash
bin/rails db:setup

bin/dev
# OR
rails server
```
