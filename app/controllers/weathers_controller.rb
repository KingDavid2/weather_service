class WeathersController < ApplicationController
  def index
    if params[:lat] && params[:lon]
      result = Weather.search(lat: params[:lat], lon: params[:lon])

      if result.data["error"].present?
        flash.now[:alert] = result.data["error"]
      else
        @current_weather = result.data
        @current_weather_image_url = result.image_url
      end
    end
  end

  def search
    if params[:city].present? || params[:state].present?
      location = GetDirectGeocoding.search(city: params[:city], state: params[:state])
      if location.is_a?(Hash) && location[:error]
        flash.now[:alert] = location[:error]
        render :index
      else
        redirect_to root_path(lat: location["lat"], lon: location["lon"])
      end
    else
      flash.now[:alert] = "Please enter city or state."
      render :index
    end
  end
end
