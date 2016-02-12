class Location < ActiveRecord::Base
  geocoded_by :locale

  def locale
    [city, state].compact.join(', ')
  end

  def coords_nil?
    self.latitude.blank? || self.longitude.blank?
  end

  def self.dedup
    grouped = Location.all.group_by{ |location| [location.city, location.state, location.latitude, location.longitude, location.id] }
    grouped.values.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each { |double| double.destroy }
    end
  end

  before_save :geocode, :if => :coords_nil?

  Location.dedup
end
