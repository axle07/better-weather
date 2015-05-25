class Location < ActiveRecord::Base
	geocoded_by :locale

	def locale
		[city, state].compact.join(', ')
	end
	
	def coords_nil?
		self.latitude.blank? || self.longitude.blank?
	end

	before_save :geocode, :if => :coords_nil?
end
