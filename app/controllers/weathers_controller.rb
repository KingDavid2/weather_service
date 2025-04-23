class WeathersController < ApplicationController
  def index
    if params[:lat] && params[:lon]
      result = GetWeather.search(lat: params[:lat], lon: params[:lon])

      if result[:error].present?
        flash.now[:alert] = result[:error]
      else
        @current_weather = result
      end
    end
  end
end
