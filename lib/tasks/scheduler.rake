namespace :weather do

  desc "TODO"
  task import_cities: :environment do
    require 'csv'

    CSV.foreach('cities3.csv', :headers => true) do |row|
      Location.create!(row.to_hash)
    end
  end

  # thanks to SO for this one:
  # http://stackoverflow.com/questions/5638543/how-to-remove-duplicates-in-mysql-using-rails
  task dedupe_cities: :environment do 
    counts = Location.group([:city, :state]).count

    dupes = counts.select{|attrs, count| count > 1}

    object_groups = dupes.map do |attrs, count|
      Location.where(:city => attrs[0], :state => attrs[1])
    end

    object_groups.each do |group|
      group.each_with_index do |object, index|
        object.destroy unless index == 0
      end
    end
  end

  task update_forecasts: :environment do
    require 'forecast_io'
    ForecastIO.api_key = '7585f78c82270a33dfedf212c3c02d73'

    @l = Location.all

    @l.each do |l|
      if l
        forecast = ForecastIO.forecast(l.latitude, l.longitude, time: Time.now.utc.to_i)
        if forecast
          l.current_forecast =  forecast.currently.icon
        else
          puts "no forecast for " + l.inspect
        end
        l.save
      else
        puts l.inspect
      end
    end
  end
end
