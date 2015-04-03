json.array!(@locations) do |location|
  json.extract! location, :id, :city, :state, :latitude, :longitude
  json.url location_url(location, format: :json)
end
