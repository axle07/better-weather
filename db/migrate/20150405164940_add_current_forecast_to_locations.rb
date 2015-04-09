class AddCurrentForecastToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :current_forecast, :string
  end
end
