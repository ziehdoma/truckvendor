class AddLatitudeAndLongitudeToVendorprofile < ActiveRecord::Migration
  def change
    add_column :vendorprofiles, :latitude, :float
    add_column :vendorprofiles, :longitude, :float
  end
end
