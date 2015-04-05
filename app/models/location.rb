class Location < ActiveRecord::Base
	reverse_geocoded_by :latitude, :longitude
	before_save :geocode #, :if => :address_changed?
end
