namespace :weather do

	desc "TODO"
  task import_cities: :environment do
		require 'csv'

		CSV.foreach('city_coords.csv', :headers => true) do |row|
			Location.create!(row.to_hash)
		end
  end

	task update_forecasts: :environment do
		require 'forecast_io'
		ForecastIO.api_key = '7585f78c82270a33dfedf212c3c02d73'

		@l = Location.take(10)

		@l.each do |l|
			forecast = ForecastIO.forecast(l.latitude, l.longitude)
			puts forecast.currently.summary
		end
	end
end
