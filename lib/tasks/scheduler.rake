namespace :weather do

	desc "TODO"
  task import_cities: :environment do
		require 'csv'

		CSV.foreach('cities3.csv', :headers => true) do |row|
			Location.create!(row.to_hash)
		end
  end

	task update_forecasts: :environment do
		require 'forecast_io'
		ForecastIO.api_key = '7585f78c82270a33dfedf212c3c02d73'

		@l = Location.all

		@l.each do |l|
			if l
				forecast = ForecastIO.forecast(l.latitude, l.longitude, time: Time.now.utc.to_i)
				l.current_forecast =  forecast.currently.icon
				l.save
			else
				puts l.inspect
			end
		end
	end
end
