namespace :weather do
  desc "TODO"
  task import_cities: :environment do
		require 'csv'

		CSV.foreach('city_coords.csv', :headers => true) do |row|
			Location.create!(row.to_hash)
		end
  end

end
