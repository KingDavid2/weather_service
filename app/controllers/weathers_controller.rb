class WeathersController < ApplicationController
  def index
    if params[:lat] && params[:lon]
      result = Weather.search(lat: params[:lat], lon: params[:lon]).data

      if result["error"].present?
        flash.now[:alert] = result["error"]
      else
        @current_weather = result
      end
    end
  end
end
