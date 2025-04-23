class AddCityStateToWeather < ActiveRecord::Migration[8.0]
  def change
    add_column :weathers, :city, :string
    add_column :weathers, :state, :string
  end
end
