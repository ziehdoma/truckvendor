class Vendorprofile < ActiveRecord::Base
	belongs_to :vendor
	attr_accessible :name, :zipcode, :phone, :description, :address, :latitude, :longitude
	geocoded_by :address
	after_validation :geocode, :if => :address_changed?
	validates_presence_of :name, :phone
	validates :phone, :phone_plausible => true
end
