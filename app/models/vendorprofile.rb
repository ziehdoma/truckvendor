class Vendorprofile < ActiveRecord::Base
	belongs_to :vendor
	attr_accessible :name, :zipcode, :phone, :description, :address, :latitude, :longitude
	geocoded_by :address
	after_validation :geocode, :if => :address_changed?

	
end
