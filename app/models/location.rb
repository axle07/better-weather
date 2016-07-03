class Location < ActiveRecord::Base
  geocoded_by :ip_address#:locale
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  def locale
    [city, state].compact.join(', ')
  end

  def coords_nil?
    self.latitude.blank? || self.longitude.blank?
  end

  before_save :geocode, :if => :coords_nil?
end
