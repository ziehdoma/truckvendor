class CreateVendorprofiles < ActiveRecord::Migration
  def change
    create_table :vendorprofiles do |t|
      t.string :name
      t.string :address
      t.integer :zipcode
      t.string :phone
      t.text :description
      t.timestamps null: false
    end
  end
end
